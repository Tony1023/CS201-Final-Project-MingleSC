const fs = require('fs');

function main() {
  fs.readFile('majors.txt', (err, data) => {
    if (err)
      throw err;
    let content = data.toString();
    let lines = content.split('\n');
    let commands = [
      'USE cs201_final_project_db;',
      'INSERT INTO major(major_name) VALUES'
    ];
    for (let i = 0; i < lines.length; ++i) {
      let query;
      if (i == lines.length - 1) 
        query = "('" + lines[i] + "')";
      else 
        query = "('" + lines[i] + "'),";
      commands.push(query);
    }
    commands[commands.length - 1] += ';';
    let file = commands.join('\n');
    fs.writeFile('majors.sql', file, err => {
      if (err)
        throw err;
    })
  });
}

main();