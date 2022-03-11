function($map) {
  element html {
  attribute lang {'en'},
    element head {
    element title { $map?title },
    element meta {
      attribute http-equiv { "Content-Type"},
      attribute content { "text/html; charset=UTF-8"}
      }
  },
  element body{ 
    element h1 {  $map?title   },
    element main { $map('content') }
    }
  }
}

