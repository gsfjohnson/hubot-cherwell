# hubot-cherwell

Hubot plugin to interact with Cherwell.

## Installation

Add **hubot-cherwell** to your `package.json` file:

```javascript
"dependencies": {
  "hubot": ">= 2.5.1",
  "hubot-cherwell": "*"
}
```

Add **hubot-cherwell** to your `external-scripts.json`:

```javascript
["hubot-cherwell"]
```

Run `npm install`

## Usage

Assuming your hubot instance is called `hubot`, you can instruct it to relay a message as follows:

`hubot: cher incident <id>`

Cherwell will be queried and when available the results will be provided.


## Configuration

It is necessary to procure an api username and password from your proteus administrator. Once obtained, set the `HUBOT_CHERWELL_URL`, `HUBOT_CHERWELL_USER`, and `HUBOT_CHERWELL_PASS` environment variables.

