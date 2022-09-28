use comrak::{markdown_to_html, ComrakOptions};
use once_cell::sync::Lazy;
use rhai::{Engine, Scope};
use std::sync::Mutex;

static SCOPE: Lazy<Mutex<Scope>> = Lazy::new(|| Mutex::new(Scope::new()));
static ENGINE: Lazy<Engine> = Lazy::new(|| Engine::new());

pub fn get_hello() -> String {
    let scope = match SCOPE.lock() {
        Ok(s) => s,
        Err(_) => return "Is poisoned!".to_string(),
    };
    match scope.get_value("hello") {
        Some(val) => val,
        None => return "There is no hello.".to_string(),
    }
}

pub fn execute_rhai(s: String) -> Option<String> {
    let mut scope = match SCOPE.lock() {
        Ok(s) => s,
        Err(_) => return None,
    };
    match ENGINE.run_with_scope(&mut scope, &s) {
        Ok(_) => Some("Run with no errors".to_string()),
        Err(e) => Some(format!("Run with errors: {e}")),
    }
}

pub fn parse_markdown(md: String) -> String {
    markdown_to_html(md.as_str(), &ComrakOptions::default())
}
