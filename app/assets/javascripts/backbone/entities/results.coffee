@App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Candidate extends Backbone.Model
  class Candidates extends Backbone.Collection
    model: Candidate

  class Response extends Backbone.Model
  class Responses extends Backbone.Collection
    model: Response

  # Single results row
  # - name
  # - votes
  # - party (optional)
  class ResultRow extends Backbone.Model
  class ResultRows extends Backbone.Collection
    model: ResultRow

  # RefCon results summary for the given region
  # - voters_total
  # - votes_total
  # - rows (ResultRow collection)
  class ResultsSummary extends Backbone.Model
    initialize: ->
      @set 'rows', new ResultRows @get 'rows'

  # RefCon results for the given Region
  # - summary (ResultsSummary) for summary display
  # - precinctResults (PrecinctResults ...)
  # - candidates (Candidates ...)
  class Entities.Results extends Backbone.Model
    parse: (data) ->
      res =
        type: data.type
        id:   data.id
        summary: new ResultsSummary data.summary

      if data.type == 'c'
        res.candidates = new Candidates data.candidates
      else
        res.responses = new Responses data.responses

      res

  class Entities.ResultsCollection extends Backbone.Collection
    model: Entities.Results

    fetchForFilter: (localityId, region, refcon) ->
      filter = locality_id: localityId
      if region?
        rid = region.get 'id'
        if region instanceof App.Entities.District
          filter.district_id = rid
        else
          filter.precinct_id = rid

      if refcon?
        type = refcon.get('type')
        id = refcon.get('id')
        if type == 'all'
          filter.category = id
        else if type == 'c'
          filter.contest_id = id
        else if type == 'r'
          filter.referendum_id = id

      @fetch
        url:   '/data/region_refcons'
        reset: true
        data:  filter

  # --- Precinct results ---

  class PrecinctRowItem extends Backbone.Model
  class PrecinctRowItems extends Backbone.Collection
    model: PrecinctRowItem

  # Results for individual precinct
  # - id
  # - votes
  # - rows (top 2) (ResultRow collection)
  class PrecinctResult extends Backbone.Model
    initialize: ->
      @set 'rows', new ResultRows @get 'rows'
  # Collection of results
  class PrecinctResults extends Backbone.Collection
    model: PrecinctResult

  # Results for the given result (recon + region)
  class Entities.PrecinctResultData extends Backbone.Model
    initialize: ->
      @set
        items:      new PrecinctRowItems
        precincts:  new PrecinctResults
        voters:     0
        ballots:    0
        votes:      0

    parse: (data) ->
      @set
        items:      new PrecinctRowItems data.items
        precincts:  new PrecinctResults data.precincts
        voters:     data.voters
        ballots:    data.ballots
        votes:      data.votes
      @._previousAttributes = null
      @trigger 'reset'

    fetchForResult: (result, region) ->
      if !result?
        @parse {}
        @trigger 'reset'
        @trigger 'sync'
        return

      filter = {}

      rid = result.get('id')
      if result.get('type') == 'c'
        filter.contest_id = rid
      else
        filter.referendum_id = rid

      if region?
        rid = region.get 'id'
        if region instanceof App.Entities.District
          filter.district_id = rid
        else
          filter.precinct_id = rid

      @fetch
        url:   '/data/precinct_results'
        reset: true
        data:  filter
