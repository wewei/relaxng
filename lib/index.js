const Promise = require('bluebird');
const fs = require('fs-extra');
const path = require('path');
const pegjs = require('pegjs');

const pathRes = name => path.join(__dirname, '../res', name);
const readRes = name => fs.readFile(pathRes(name), 'utf8');

Promise
  .map(['rnc.pegjs', 'input.rnc'], readRes)
  .spread((syntax, input) => {
    const parser = pegjs.generate(syntax);
    const ast = parser.parse(input.trim());

    console.log(JSON.stringify(ast, null, 2));
  });
