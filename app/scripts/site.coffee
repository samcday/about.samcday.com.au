class VerbosityMeter
    constructor: (@interval = 700) ->
        @desiredState = @current
    onleaveterse: (event, from, to) ->
        if to is "verbose"
            @show "moderate"
            @show "verbose"
        if to is "moderate"
            @show "moderate"
        return @stateAnimating from, to, @
    onleavemoderate: (event, from, to) ->
        animating = false
        if to is "terse"
            @hide "moderate"
        if to is "verbose"
            @show "verbose"
        return @stateAnimating from, to, @
    onleaveverbose: (event, from, to) ->
        if to is "terse"
            @hide "moderate"
            @hide "verbose"
        if to is "moderate"
            @hide "verbose"
        return @stateAnimating from, to, @
    onchangestate: (event, from, to) ->
        return if from is "none"
        if to isnt @desiredState
            @[@desiredState]()
    show: (type) ->
        $els = $ ".#{type}"
        $els.css("display", "inline-block").addClass "animated fadeInUp"
        setTimeout ->
            $els.removeClass "animated fadeInUp"
        , @interval
    hide: (type) ->
        $els = $ ".#{type}"
        $els.addClass "animated fadeOutDown"
        setTimeout ->
            $els.removeClass "animated fadeOutDown"
            $els.css("display", "none")
        , @interval
    stateAnimating: (from, to, fsm) ->
        setTimeout =>
            console.log "Done animating #{from} to #{to}"
            @transition()
        , @interval
        return StateMachine.ASYNC
    go: (state) ->
        if @can state then @[@desiredState = state]() else @desiredState = state

verbosityStateMachine = StateMachine.create
    target: VerbosityMeter.prototype
    initial: "terse"
    events: [
        { name: "terse", from: ["moderate", "verbose"], to: "terse" }
        { name: "moderate", from: ["terse", "verbose"], to: "moderate" }
        { name: "verbose", from: ["terse", "moderate"], to: "verbose" }
    ]
verbosity = new VerbosityMeter
# setTimeout ->
#     blah.verbose()
#     blah.go "moderate"
# , 1000

# verbosityStateMachine = StateMachine.create
#     initial: "terse"
#     events: [
#         { name: "terse", from: ["moderate", "verbose"], to: "terse" }
#         { name: "moderate", from: ["terse", "verbose"], to: "moderate" }
#         { name: "verbose", from: ["terse", "moderate"], to: "verbose" }
#     ]
#     callbacks:
#
#         # onentermoderate: (event, from, to) ->
#         #     if from is "terse"
#         #         setTimeout ->
#         #             console.log "This is where we'd totally animate moderate text in."
#         #             verbosityStateMachine.transition()
#         #         , 1000
#         #         return StateMachine.ASYNC
#         onleavemoderate: (event, from, to) ->
#             if to is "terse"
#                 setTimeout ->
#                     console.log "This is where we'd totally animate moderate text out."
#                     verbosityStateMachine.transition()
#                 , 1000
#                 return StateMachine.ASYNC
#         onchangestate: (event, from, to) ->
#             console.log "Changed from #{from} to #{to}"
# console.log verbosityStateMachine
# verbosityStateMachine.moderate()

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


    setVerbosity = (verbosity) ->
        # desiredState = verbosity
        # animateVerbosity()

        # if verbosity is "moderate"
        #     ($ ".moderate").css("display", "inline-block").addClass "animated fadeInUp"
        #     setTimeout ->
        #         ($ ".moderate").removeClass "animated"
        #     , 50
        # if (["moderate", "verbose"].indexOf verbosity) > -1
        #     $body.addClass "show-moderate" unless $body.hasClass "show-moderate"
        #
        # $body.toggleClass "show-verbose", verbosity is "verbose"

    siteInit = ->
        ($ "#verbosity-meter").click (ev) ->
            verbosity.go ($ ev.target).data("verbosity")
            # setVerbosity ($ ev.target).data("verbosity")

        jumbotronHeight = $jumbotron.outerHeight()
        $win.scroll $.throttle 1000/20, ->
            scrollTop = $win.scrollTop()
            if (scrollTop > jumbotronHeight) and state.showingJumbotron
                state.showingJumbotron = false
                $navbar.css opacity: 1
            else if (scrollTop < jumbotronHeight) and not state.showingJumbotron
                state.showingJumbotron = true
                $navbar.css opacity: 0

        # setTimeout ->
        #     # ($ ".moderate").addClass "animated fadeInUp"
        # , 1000

    $win.on "load", ->
        siteInit()





# var fsm = StateMachine.create({

#   initial: 'menu',

#   events: [
#     { name: 'play', from: 'menu', to: 'game' },
#     { name: 'quit', from: 'game', to: 'menu' }
#   ],

#   callbacks: {

#     onentermenu: function() { $('#menu').show(); },
#     onentergame: function() { $('#game').show(); },

#     onleavemenu: function() {
#       setTimeout(function() {
#         fsm.transition();
#       }, 1000)
#       return StateMachine.ASYNC; // tell StateMachine to defer next state until we call transition (in fadeOut callback above)
#     },

#     onleavegame: function() {
#       $('#game').slideDown('slow', function() {
#         fsm.transition();
#       });
#       return StateMachine.ASYNC; // tell StateMachine to defer next state until we call transition (in slideDown callback above)
#     },

#       onchangestate: function(event, from, to) { console.log("CHANGED STATE: " + from + " to " + to); }
#   }
# });

# setTimeout(function() {
#   console.log(fsm.play());
#   console.log(fsm.can("play"));
#   // console.log(fsm.play());
# }, 1000);
