@App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->

  class Entities.ScoreboardInfo extends Backbone.Model

  API =
    getScoreboardInfo: ->
      unless Entities.scoreboardInfo?
        contests = App.request 'entities:contests'

        Entities.scoreboardInfo = sb = new Entities.ScoreboardInfo
          localityId:       gon.locality_id
          localityName:     gon.locality_name
          localityInfo:     gon.locality_info
          electionInfo:     gon.election_info
          contest:          contests.first()
          regionLabel:      -> if !@region then "All Precincts" else @region.get('name')
          region:           null
          percentReporting: -> 29
  
        sb.on 'change:contest', ->
          sb.set 'region', null

        App.vent.on 'region:selected', (region) ->
          sb.set 'region', region

      Entities.scoreboardInfo

  App.reqres.setHandler 'entities:scoreboardInfo', -> API.getScoreboardInfo()