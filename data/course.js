const request = require('request');
const fs = require('fs');
const fetch = require('node-fetch');


function main() {
  request('https://web-app.usc.edu/web/soc/api/depts/20191', (err, res, body) => {
    let info = JSON.parse(body);
    scrapeCourses(info);
  });
}

let scrapeCourses = data => {
  let coll = data.department;
  let depts = [];
  for (let i = 0; i < coll.length; ++i) {
    let dept = coll[i].department;
    if (dept === undefined)
      continue;
    if (dept instanceof Array) {
      for (let j = 0; j < dept.length; ++j) {
        depts.push(dept[j].code);
      }
    } else {
      depts.push(dept.code);
    }
  }
  let courses = { };
  let left = depts.length;
  let requests = depts.map((dept) => {
    return (fetch('https://web-app.usc.edu/web/soc/api/classes/' + dept + '/20191')
      .then( res => res.json() )
      .then( data => {
        console.log(dept, --left + ' departments left.');
        courses[dept] = data.OfferedCourses.course;
      })
      .catch( err => fetch_retry('https://web-app.usc.edu/web/soc/api/classes/' + dept + '/20191', 5)));
  });
  Promise.all(requests).then(() => {
    console.log('finished');
    fs.writeFile('courses.json', JSON.stringify(courses), err => {
      if (err)
        throw err;
      console.log('Scraping finished.');
    });
  });

};

const fetch_retry = (url, n) => fetch(url).catch( err => {
  if (n === 1) console.log(err);
  return fetch_retry(url, n - 1);
});

// runs main function
main();