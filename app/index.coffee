'use strict'

require.config {
    baseUrl: '.'
    paths:
        'require-css': "#{window.APP_ROOT || ''}/bower/require-css/css"
        'jquery': "#{window.APP_ROOT || ''}/bower/jquery/dist/jquery"

        'angular': "#{window.APP_ROOT || ''}/bower/angular/angular"
        
        'ionic': "#{window.APP_ROOT || ''}/bower/ionic/js/ionic.bundle.min"

        # 'tubular': "#{window.APP_ROOT || ''}/vendor/tubular/js/jquery.tubular.1.0"

    shim:
        'jquery':
            exports: 'jQuery'
        'angular':
            deps: ['jquery']
            exports: 'angular'
    map:
        '*':
            'css': 'require-css'
}


require ['jquery'], ($, t) ->

    app = angular.module('app', ['ionic'])

    app.controller "AppCtrl", ($scope, $ionicModal) ->

        console.log "AppCtrl"

        $scope.playing = false
        $scope.duration = '2'

        audio = new Audio "#{window.APP_ROOT || ''}/assets/guided/#{$scope.duration}min.m4a"
        audio.loop = true


        $ionicModal.fromTemplateUrl("views/duration.html",
                scope: $scope
                animation: "slide-in-up"
            ).then (modal) ->

                $scope.durationModal = modal

        $scope.openDurationModal = () ->

            $scope.durationModal.show()

            $scope.$on "$destroy", ->
                # console.log arguments, "modal.destroy"
                $scope.durationModal.remove()

            $scope.$on "modal.hidden", ->
                # console.log arguments, "modal.hidden"

            $scope.$on "modal.removed", ->
                # console.log arguments, "modal.removed"

        $scope.closeDurationModal = ->

            $scope.durationModal.hide()


        $scope.play = () ->

            $scope.playing = true

            audio.play()

        $scope.pause = () ->

            audio.pause()

        $scope.stop = () ->

            $scope.playing = false

            audio.pause()
            audio.currentTime = 0

        $scope.durationChange = (duration) ->

            $scope.duration = duration

            console.log $scope.duration

            audio = new Audio "#{window.APP_ROOT || ''}/assets/guided/#{$scope.duration}min.m4a"
            audio.loop = true

            $scope.closeDurationModal()



    app.run ($ionicPlatform, $rootScope, $window, $state) ->

        console.log 'app:run()'

        $ionicPlatform.ready ->

            cordova.plugins.Keyboard.hideKeyboardAccessoryBar true  if window.cordova and window.cordova.plugins.Keyboard

            # org.apache.cordova.statusbar required
            StatusBar.styleDefault()  if window.StatusBar


    app.config ($stateProvider, $urlRouterProvider) ->

        console.log 'app:config()'

        $stateProvider.state("app",
            url: "/app"
            templateUrl: "views/app.html"
            controller: "AppCtrl"
        )

        $urlRouterProvider.otherwise '/app'

    angular.element(document).ready () ->
        angular.bootstrap(document, ['app'])

