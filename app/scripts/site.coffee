class BetterVerbosityMeter
    constructor: (@type, @interval = 400) ->
        @desiredState = @current
    go: (action) ->
        newState = if action is "show" then "visible" else "hidden"
        return if newState is @newState
        @desiredState = newState
        @[action]() if @can action
    onleavevisible: ->
        $els = $ ".#{@type}"
        $els.addClass "animated fadeOutDown"
        setTimeout =>
            $els.removeClass "animated fadeOutDown"
            $els.css("display", "none")
            @transition()
        , @interval
        return StateMachine.ASYNC
    onleavehidden: ->
        $els = $ ".#{@type}"
        $els.css("display", "inline-block").addClass "animated fadeInUp"
        setTimeout =>
            $els.removeClass "animated fadeInUp"
            @transition()
        , @interval
        return StateMachine.ASYNC
    onchangestate: (event, from, to) ->
        return if from is "none"
        if to isnt @desiredState
            newAction = if @desiredState is "hidden" then "hide" else "show"
            @[newAction]()

 StateMachine.create
    target: BetterVerbosityMeter.prototype
    initial: "hidden"
    events: [
        { name: "hide", from: "visible", to: "hidden" }
        { name: "show", from: "hidden", to: "visible" }
    ]

moderateVerbosity = new BetterVerbosityMeter "moderate", 300
verboseVerbosity = new BetterVerbosityMeter "verbose", 300

jQuery ($) ->
    $win = $ window
    $body = $ document.body
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

    currentAnimations = {}
    desiredState = "terse"
    animateVerbosity = ->

    siteInit = ->
        ($ "#verbosity-meter-container input").bind "slider:changed", (event, data) ->
            level = ["terse", "moderate", "verbose"][data.value - 1]
            moderateVerbosity.go if level is "terse" then "hide" else "show"
            verboseVerbosity.go if level is "verbose" then "show" else "hide"

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
