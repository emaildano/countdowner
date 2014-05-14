# Countdowner

Count down app for Geckoboard widgets, that returns the countdown for
**business days**.

See [this][1] for more details.

[1]http://www.geckoboard.com/developers/custom-widgets/widget-types/rag-numbers-only

## How it works

`curl -X POST http://countdownerapp.herokuapp.com/?date=2014-05-21&msg=days+Until+Prod+Deploy`

or

`curl --data "date=2014-05-21&msg=Until+Prod+Deploy" http://countdownerapp.herokuapp.com/`

returns

`{"item":[{},{"value":"5","text":"business days days Until Prod Deploy"},{}]}`
