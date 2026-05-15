const fs = require('fs');
const path = require('path');

const dirs = ['config', 'middleware', 'routes'];

dirs.forEach(dir => {
  const dirPath = path.join(__dirname, dir);
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
    console.log(`✓ Created ${dir} directory`);
  }
});

console.log('✓ All directories created');
