var gulp = require('gulp');
var handlebars = require('gulp-handlebars');
var merge = require('merge-stream');
var wrap = require('gulp-wrap');
var declare = require('gulp-declare');
var concat = require('gulp-concat');
var del = require('del');
var minify = require('gulp-minify');
var Handlebars = require('handlebars');

gulp.task('codemirror', function() {
    var codemirror_lib = gulp.src([
        'node_modules/codemirror/lib/codemirror.js',
        'node_modules/codemirror/lib/codemirror.css',
    ]).pipe(gulp.dest('target/gulp/codemirror/'));

    var codemirror_xml = gulp.src([
        'node_modules/codemirror/mode/xml/xml.js',
    ]).pipe(gulp.dest('target/gulp/codemirror/mode/xml'));
    
    var codemirror_sparql = gulp.src([
        'node_modules/codemirror/mode/sparql/sparql.js',
    ]).pipe(gulp.dest('target/gulp/codemirror/mode/sparql'));

    return merge(codemirror_lib, codemirror_xml, codemirror_sparql);
});

gulp.task('scripts', function() {
    return gulp.src([
        'node_modules/jquery/dist/jquery.min.js',
        'node_modules/bootstrap/dist/js/bootstrap.min.js',
        'node_modules/handlebars/dist/handlebars.runtime.min.js',
    ]).pipe(gulp.dest('target/gulp/vendor/js'));
});

gulp.task('styles', function() {
    return gulp.src([
        'node_modules/bootstrap/dist/css/bootstrap.min.css',
        'node_modules/bootstrap/dist/css/bootstrap.min.css.map',
        'node_modules/font-awesome/css/font-awesome.css',
        'node_modules/font-awesome/css/font-awesome.min.css',
        'node_modules/font-awesome/css/font-awesome.css.map',
    ]).pipe(gulp.dest('target/gulp/vendor/css/'));
 });

gulp.task('fonts', function() {
    return gulp.src([
        'node_modules/bootstrap/dist/fonts/*',
        'node_modules/font-awesome/fonts/*',
    ]).pipe(gulp.dest('target/gulp/vendor/fonts/'));
 });

gulp.task('templates', function() {
    return gulp.src('src/main/handlebars/*.hbs')
               .pipe(handlebars({ handlebars: Handlebars }))
               .pipe(wrap('Handlebars.template(<%= contents %>)'))
		       .pipe(declare({
		           namespace: 'Handlebars.templates',
		           noRedeclare: true,
		       }))
		       .pipe(concat('templates.js'))
		       .pipe(minify())
		       .pipe(gulp.dest('target/gulp/scripts'));
});


gulp.task('build', gulp.series(
        'scripts',        
        'templates',
        'styles',
        'fonts',
        'codemirror',
));

gulp.task('clean', function() {
	return del([
		'target/gulp/**/*.js',
		'target/gulp/**/*.css',
        'target/gulp/**/*.map',
        'target/gulp/**/*.eot',
        'target/gulp/**/*.png',
        'target/gulp/**/*.svg',
        'target/gulp/**/*.ttf',
        'target/gulp/**/*.woff',
        'target/gulp/**/*.otf',
        'target/gulp/**/*.woff2',
		
	]);
});
