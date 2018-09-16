const path = require('path');
const mkdirp = require('mkdirp');
const rimraf = require('rimraf');
const copyDir = require('copy-dir');

const srcPath = path.join(__dirname, '..', 'services', 'smart-contracts', 'src', 'build', 'contracts');

const destPathUi = path.join(__dirname, '..', 'services', 'ui', 'src', 'dapp', 'src', 'contracts');

rimraf.sync(destPathUi);

mkdirp.sync(destPathUi);

copyDir.sync(srcPath, destPathUi);
