'use strict'

require.config {
    baseUrl: '.'
    paths:
        'require-css': "#{window.APP_ROOT || ''}/bower/require-css/css"
        'jquery': "#{window.APP_ROOT || ''}/bower/jquery/dist/jquery"
        'angular': "#{window.APP_ROOT || ''}/bower/angular/angular"

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


require ['angular'], (angular) ->

    app = angular.module('app', ['ionic'])

    app.controller "AppCtrl", ($scope) ->

        console.log "AppCtrl"

    app.controller "ProfileCtrl", ($scope) ->

        console.log "ProfileCtrl"

    app.controller "CalmCtrl", ($scope) ->

        console.log "CalmCtrl"

    app.run ($ionicPlatform, $rootScope, $window, $state) ->

        $ionicPlatform.ready ->

            cordova.plugins.Keyboard.hideKeyboardAccessoryBar true  if window.cordova and window.cordova.plugins.Keyboard

            # org.apache.cordova.statusbar required
            StatusBar.styleDefault()  if window.StatusBar


    app.config ($stateProvider, $urlRouterProvider) ->


        $stateProvider.state("app",
            url: "/app"
            abstract: true
            templateUrl: "views/tab.html"
            # controller: "AppCtrl"
        ).state("app.calm",
            url: "/calm"
            views:
                calm:
                    templateUrl: "views/calm.html"
                    controller: "CalmCtrl"
        )
        .state("app.profile",
            url: "/profile"
            views:
                profile:
                    templateUrl: "views/profile.html"
                    controller: "ProfileCtrl"
        )


        $urlRouterProvider.otherwise "/calm"

    # angular.element(document).ready () ->
    #     angular.bootstrap(document, ['app'])

