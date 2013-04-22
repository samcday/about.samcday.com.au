jQuery ($) ->
	$win = $ window
	$jumbotron = $ "#jumbotron"
	$navbar = $ "#siteNav"

	state = 
		showingJumbotron: true
		
	$navbar.css opacity: 0
	$navbar.addClass "opacityAnim"

	$navbar.on "click", "a", (ev) ->
		# var aTag = $("a[name='"+ aid +"']");
		# $('html,body').animate({scrollTop: aTag.offset().top},'slow');
		target = ($ ev.target).attr "href"
		($ "body").animate { scrollTop: ($ target).offset().top }, "slow", "easeInOutQuad"
		return false

	siteInit = ->

		jumbotronHeight = $jumbotron.outerHeight()
		$win.scroll $.throttle 1000/20, ->
			scrollTop = $win.scrollTop()
			if (scrollTop > jumbotronHeight) and state.showingJumbotron
				state.showingJumbotron = false
				$navbar.css opacity: 1
			else if (scrollTop < jumbotronHeight) and not state.showingJumbotron
				state.showingJumbotron = true
				$navbar.css opacity: 0

	$win.on "load", ->
		siteInit()