# Countdowner

Count down app for Geckoboard widgets, that returns the countdown for
**business days**.

See [Geckoboard documentation](http://www.geckoboard.com/developers/custom-widgets/widget-types/rag-numbers-only) for more details.


## How it works


### Days countdown

    curl -X POST http://countdownerapp.herokuapp.com/?date=2014-05-21&msg=days+Until+Prod+Deploy

or

    curl --data "date=2014-05-21&msg=Until+Prod+Deploy" http://countdownerapp.herokuapp.com/

returns

    {"item":[{},{"value":"5","text":"business days days Until Prod Deploy"},{}]}

### Pull request count

    curl --data 'repo=tribunals' http://localhost:9393/pull-requests

returns

    {"item":[{"value":"2","text":"open pull requests"},{},{}]}
