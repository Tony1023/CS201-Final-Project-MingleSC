const fs = require('fs');

function main() {
  fs.readFile('courses.json', (err, data) => {
    if (err) {
      throw err;
    }
    data = JSON.parse(data);
    let commands = [
      'USE cs201_final_project_db;',
      'INSERT INTO courses(course_prefix, course_number, course_name) VALUES'
    ];
    for (let key in data) {
      let deptCourse = data[key];
      for (let i = 0; i < deptCourse.length; ++i) {
        let course = deptCourse[i].CourseData;
        let prefix = course.prefix;
        let number = course.number;
        let title = course.title;
        let query;
        if (i == deptCourse.length - 1)
          query = "('" + prefix + "', " + number + ", '" + title + "')";
        else
          query = "('" + prefix + "', " + number + ", '" + title + "'),";
        console.log(query);
        commands.push(query);
      }
    }
    commands[commands.length - 1] += ';';
    let file = commands.join('\n');
    fs.writeFile('courses.sql', file, err => {
      if (err)
        throw err;
    })
  })
}

main();