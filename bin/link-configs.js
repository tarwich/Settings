const { existsSync, statSync, symlinkSync } = require('fs');
const { resolve } = require('path');

// Windows = HOMEPATH, Mac = HOME
const { HOMEPATH, HOME = HOMEPATH } = process.env;

const expand = path => resolve(
  path.replace(/^~/, HOME)
  .replace(/%(\w+)%/g, (_, key) => process.env[key])
);

/**
 * Create a file in <from> pointing to <to>
 *
 * @param {string} from The path where the link should be created
 * @param {string} to The path where the existing file is
 */
const ln = (from, to) => {
  from = expand(from);
  to = expand(to);
  if (!existsSync(to)) return console.log(`Target ${to} doesn't exist`);
  if (existsSync(from)) return console.log(`Path ${from} already exists`);
  const type = statSync(to).isFile() ? 'file' : 'junction';
  symlinkSync(to, from, type);
}

ln('%APPDATA%/mps-youtube/mpv-input.conf', 'mpv/input.conf');
ln('%APPDATA%/mpv', 'mpv')
