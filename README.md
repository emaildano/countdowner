# Countdowner

Count down app for Geckoboard widgets, that returns the countdown for
**business days**.

See [Geckoboard documentation](http://www.geckoboard.com/developers/custom-widgets/widget-types/rag-numbers-only) for more details.


## How it works


### Days countdown

It returns the number of working days until the given date. It does
take into account **all UK holidays** and weekends.

The endpoint is:

    /until/:date/:message

Example:

    curl http://countdownerapp.herokuapp.com/until/2014-05-21/Until%20Prod%20Deploy

returns

    {"item":[{},{"value":"5","text":"business days Until Prod Deploy"},{}]}

### Pull request count

The endpoint is:

    /pulls/:repo

(Where **:repo** is a repository name under **/ministryofjustice/**.)

Example:

    curl http://localhost:9393/pulls/tribunals

returns

    {"item":[{"value":"2","text":"open pull requests"},{},{}]}
