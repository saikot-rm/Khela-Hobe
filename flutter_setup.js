const fs = require('fs');
const path = require('path');

const baseDir = path.join(__dirname, 'flutter_frontend', 'lib');

// Directory structure
const dirs = [
  'widgets',
  'dashboards',
  'screens/auth',
  'providers',
  'models',
];

// Create all directories
dirs.forEach(dir => {
  const dirPath = path.join(baseDir, dir);
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
    console.log(`✓ Created ${dir}`);
  }
});

console.log('\n✓ Flutter project structure created!');
console.log('\nNext steps:');
console.log('1. Copy the generated .dart files to their respective folders');
console.log('2. Run: flutter pub get');
console.log('3. Run: flutter run');
