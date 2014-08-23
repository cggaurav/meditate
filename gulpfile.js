var plugins = require("gulp-load-plugins")();
var gulp = require('gulp');
var gutil = require('gulp-util');
var bower = require('bower');
var connect = require('gulp-connect');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var jade = require('gulp-jade');
var coffee = require('gulp-coffee');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var sh = require('shelljs');
var argv = require('yargs').argv;
var awspublish = require("gulp-awspublish");
var _ = require("lodash");
var plumber = require('gulp-plumber');
var say = require('say');
var stylus = require('gulp-stylus');


var paths = {
    sass: ['./app/**/*.scss', '!./app/vendor/**'],
    stylus: ['./app/**/*.styl', '!./app/vendor/**'],
    coffee: './app/**/*.coffee',
    jade: './app/**/*.jade',
    vendor: './app/vendor/**',
    bower: './app/bower/**',
    target: './ionic/www',
    ionic:{
        source: './ionic/',
        css: './ionic/www/css',
        sass: '/app/vendor/bower/ionic/scss/ionic.scss'
    },
    assets: {
        all: './app/assets/**',
        fonts: './app/assets/fonts',
        images: './app/assets/images',
        icons:'./app/assets/icons'
    }
};

gulp.task('default', ['sass', 'stylus', 'coffee', 'jade', 'bower', 'vendor', 'assets']);
gulp.task('build', ['sass', 'stylus', 'coffee', 'jade', 'bower', 'vendor', 'assets']);


gulp.task('bower', function(){
    gulp.src(paths.bower)
        .pipe(gulp.dest(paths.target + '/bower'));
})

gulp.task('vendor', function(){
    gulp.src(paths.vendor)
        .pipe(gulp.dest(paths.target + '/vendor'));
})

gulp.task('assets', function(){
    gulp.src(paths.assets.all)
        .pipe(gulp.dest(paths.target + '/assets'));
})

gulp.task('sass', function(done) {
    gulp.src(paths.sass)
        .pipe(plumber())
        .pipe(sass({ errLogToConsole: true} ))
        .pipe(rename({ extname: '.css' }))
        // .pipe(concat('style.css'))
        .pipe(gulp.dest(paths.target))
        .on('end', done);
});


gulp.task('stylus', function () {
    gulp.src(paths.stylus)
        .pipe(stylus())
        .pipe(gulp.dest(paths.target));
});

gulp.task('coffee', function(done) {
    gulp.src(paths.coffee)
        .pipe(plumber())
        .pipe(coffee({bare: true}).on('error', gutil.log))
        .pipe(gulp.dest(paths.target))
        .on('end', done)
})

gulp.task('jade', function(done) {
    gulp.src(paths.jade)
        .pipe(plumber())
        .pipe(jade().on('error', gutil.log))
        .pipe(gulp.dest(paths.target))
        .on('end', done)
})

gulp.task('watch', ['build', 'connect'], function() {
    gulp.watch(paths.sass, ['sass'])
    gulp.watch(paths.stylus, ['stylus'])
    gulp.watch(paths.coffee, ['coffee'])
    gulp.watch(paths.jade, ['jade'])
});


gulp.task('default', ['sass', 'stylus', 'coffee', 'jade']);


gulp.task('ionic-sass', function(done) {
    gulp.src(paths.ionic.sass)
        .pipe(sass())
        .pipe(gulp.dest(paths.ionic.css))
        .pipe(minifyCss({keepSpecialComments: 0}))
        .pipe(rename({ extname: '.min.css' }))
        .pipe(gulp.dest(paths.ionic.css))
        .on('end', done);
});


gulp.task('install', ['git-check'], function() {
    return bower.commands.install()
        .on('log', function(data) {
            gutil.log('bower', gutil.colors.cyan(data.id), data.message);
        });
});

gulp.task('git-check', function(done) {
    if (!sh.which('git')) {
        console.log(
            '  ' + gutil.colors.red('Git is not installed.'),
            '\n  Git, the version control system, is required to download Ionic.',
            '\n  Download git here:', gutil.colors.cyan('http://git-scm.com/downloads') + '.',
            '\n  Once git is installed, run \'' + gutil.colors.cyan('gulp install') + '\' again.'
        );
        process.exit(1);
    }
    done();
});

gulp.task("connect", function() {
    return plugins.connect.server({
        root: [paths.target],
        port: 9002,
        livereload: true,
        hostname: 'localhost',
        middleware: function(connect, options) {
            return [
                function(req, res, next) {
                    res.setHeader('Access-Control-Allow-Origin', '*');
                    res.setHeader('Access-Control-Allow-Methods', '*');
                    return next();
                }
            ];
        }
    });
});
