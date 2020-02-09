'use strict';

const core  = require('@actions/core');

function run(bitness) {
  try {
    if (process.platform === 'win32') {
      console.log (`Setting up ${bitness}-bit environment...`);
      const newPath = process.env['PATH'].replace(/[^;]+?(CMake|mingw|OpenSSL|Strawberry)[^;]*;/g, '');
      core.exportVariable('PATH', newPath);
      console.log(`New PATH=${newPath}`);

      const topDir = process.env['SystemDrive'] + "/tools/msys64";

      core.exportVariable('MSYS2', topDir);
      console.log(`New MSYS2=${topDir}`);

      const usrBinPath = `${topDir.replace(/\//g, "\\")}\\usr\\bin`;
      core.addPath(usrBinPath);
      console.log(`Added path ${usrBinPath}`);

      const bitnessPath = `${topDir.replace(/\//g, "\\")}\\mingw${bitness}\\bin`;
      core.addPath(bitnessPath);
      console.log(`Added path ${bitnessPath}`);

      const makePath = `${topDir}/usr/bin/make.exe`;
      core.exportVariable('MAKE', makePath);
      console.log(`New MAKE=${makePath}`);
    }
  } catch (error) {
    core.setFailed(error.message);
  }
}

const bitness = process.argv.find(function(element) { return ['32', '64'].indexOf(element) > -1})
run(bitness)

