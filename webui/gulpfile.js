var gulp = require('gulp');
var handlebars = require('gulp-handlebars');
var merge = require('merge-stream');
var wrap = require('gulp-wrap');
var declare = require('gulp-declare');
var concat = require('gulp-concat');
var del = require('del');
var minify = require('gulp-minify');
var rev = require('gulp-rev');
var babel = require('gulp-babel')
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


gulp.task('jslint', function() {
    const jshint = require('gulp-jshint');
    return gulp.src([
      'src/main/webapp/scripts/*.js',
      'src/main/javascript/*.js',
    ])
    .pipe(jshint())
    .pipe(jshint.reporter('default'));
});


gulp.task('csslint', function() {
    const stylelint = require('gulp-stylelint');
    return gulp.src([
      'src/main/webapp/css/*.css'
    ])
    .pipe(stylelint({
        reporters: [
            {formatter: 'string', console: true}
        ]
    }));
});


gulp.task('lint', gulp.series(
    'jslint',
    'csslint')
);


gulp.task('jqueryui', function() {
	var jscss = gulp.src([
		'node_modules/jquery-ui-dist/*.min.js',
		'node_modules/jquery-ui-dist/*.min.css',
	]).pipe(gulp.dest('target/gulp/jquery-ui'));
	
	var images = gulp.src([
		'node_modules/jquery-ui-dist/images/*',		
	]).pipe(gulp.dest('target/gulp/jquery-ui/images'));
	
	return merge(jscss, images);
})


gulp.task('scripts', function() {
    return gulp.src([
        'node_modules/jquery/dist/jquery.min.js',
        'node_modules/bootstrap/dist/js/bootstrap.min.js',
        'node_modules/handlebars/dist/handlebars.runtime.min.js',
        'node_modules/url-polyfill/url-polyfill.min.js',
    ])
    .pipe(gulp.dest('target/gulp/vendor/js'));
});


gulp.task('jsbundle', function() {
	return gulp.src([
		'src/main/javascript/*.jsx',
		'src/main/javascript/*.js',
	])
	.pipe(babel({
		presets: ['@babel/preset-env', '@babel/preset-react']
  }))
  .pipe(concat('bundle.js'))
  .pipe(minify())
	.pipe(gulp.dest('target/gulp/js'));
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
        'jqueryui',
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
