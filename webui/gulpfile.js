var gulp = require('gulp');
var handlebars = require('gulp-handlebars');
var wrap = require('gulp-wrap');
var declare = require('gulp-declare');
var concat = require('gulp-concat');
var del = require('del');
var minify = require('gulp-minify');


gulp.task('templates', function() {
    return gulp.src('src/main/javascript/templates/*.hbs')
        	   .pipe(handlebars())
               .pipe(wrap('Handlebars.template(<%= contents %>)'))
		       .pipe(declare({
		           namespace: 'Lodestar.templates',
		           noRedeclare: true,
		       }))
		       .pipe(concat('templates.js'))
		       .pipe(minify())
		       .pipe(gulp.dest('target/js'));
});


gulp.task('build', gulp.series('templates'));


gulp.task('clean', function() {
	return del([
		'target/js/*.js'
	]);
});
