use comrak::{markdown_to_html, ComrakOptions};
use gluon::{
    new_vm, primitive,
    vm::{
        self,
        api::{Hole, OpaqueValue},
    },
    Thread, ThreadExt,
};

fn print(s: String) -> String {
    s
}

fn load_print(vm: &Thread) -> vm::Result<vm::ExternModule> {
    vm::ExternModule::new(vm, primitive!(1, print))
}

pub fn execute_gluon(s: String) -> String {
    let vm = new_vm();

    let mut database = vm.get_database_mut();
    database.set_full_metadata(true);
    database.run_io(true);

    let (io, thread) = vm
        .run_expr::<OpaqueValue<&Thread, Hole>>("Dart", &s)
        .unwrap();
    format!("script: {:?}", io)
}

pub fn parse_markdown(md: String) -> String {
    markdown_to_html(md.as_str(), &ComrakOptions::default())
}
