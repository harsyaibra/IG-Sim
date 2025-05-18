$images = Get-ChildItem -Path "$PSScriptRoot/images" -Include *.jpg, *.png -Name
$videos = Get-ChildItem -Path "$PSScriptRoot/images" -Include *.mp4, *.webm -Name

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>IG Sim</title>
  <style>
    body {
      margin: 0;
      scroll-snap-type: y mandatory;
      overflow-y: scroll;
      height: 100vh;
      background: black;
    }
    .post {
      scroll-snap-align: start;
      height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    img, video {
      max-width: 100%;
      max-height: 100%;
    }
    video {
      display: block;
    }
  </style>
</head>
<body>
"@

foreach ($img in $images) {
  $html += "<div class='post'><img src='images/$img' /></div>`n"
}

foreach ($vid in $videos) {
  $html += "<div class='post'><video src='images/$vid' muted loop playsinline></video></div>`n"
}

$html += @"
<script>
const videos = document.querySelectorAll("video");

const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    const vid = entry.target;
    if (entry.isIntersecting) {
      vid.play();
    } else {
      vid.pause();
    }
  });
}, { threshold: 0.75 });

videos.forEach(video => observer.observe(video));
</script>
</body>
</html>
"@

$html | Out-File "$PSScriptRoot/index.html" -Encoding utf8
