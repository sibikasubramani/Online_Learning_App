import 'dart:io';

void main() {
  final file = File('lib/data/mock_data.dart');
  var content = file.readAsStringSync();

  final replacements = {
    'Python': 'assests/images/PYTHON THUMBNAIL.jpg',
    'Java': 'assests/images/JAVA THAMBNAIL.png',
    'UI/UX': 'assests/images/UI THUMBNAIL.jpg',
    'Database': 'assests/images/DATABASE THUMBNAIL.jpg',
    'DevOps': 'assests/images/DEVOPS THUBMNAIL.jpg',
    'Machine Learning': 'assests/images/MACHINE_LEARNING THUMBNAIL.jpg',
    'Data Science': 'assests/images/DATASCIENCE THUBMNAIL.jpg',
    'Android': 'assests/images/MOBILE APP THUMBNAIL.jpg',
    'iOS': 'assests/images/MOBILE APP THUMBNAIL.jpg',
    'React Native': 'assests/images/MOBILE APP THUMBNAIL.jpg',
    'Flutter': 'assests/images/FLUTTER THUMBNAIL.webp',
    'Web Development': 'assests/images/WEB DEVELOPMENT THAMBNAIL.jpg',
    'Game Development': 'assests/images/2D-3D GAME DEVELOPMENT THUMBNAIL.jpg',
    'Cloud Computing': 'assests/images/AWS THUMBNAIL.png',
    'DSA': 'assests/images/DATA STRUCTURES & ALGORITHMS THUMBNAIL.png',
    'Cyber Security': 'assests/images/ETHICAL HACKING THUMBNAIL.png',
    

  };

  final regex = RegExp(r"category:\s*'([^']+)',\s*thumbnail:\s*'([^']+)',");
  content = content.replaceAllMapped(regex, (match) {
    final category = match.group(1)!;
    final oldThumbnail = match.group(2)!;
    
    final newThumbnail = replacements[category] ?? oldThumbnail;
    
    return "category: '$category',\n      thumbnail: '$newThumbnail',";
  });

  file.writeAsStringSync(content);
  print('Done!');
}
