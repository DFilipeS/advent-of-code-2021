mod day_1;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let day: u8 = args
        .get(1)
        .expect("missing day")
        .parse()
        .expect("day is invalid");
    let part: u8 = args
        .get(2)
        .expect("missing part")
        .parse()
        .expect("part is invalid");

    match (day, part) {
        (1, 1) => day_1::solve_part_1(),
        (1, 2) => day_1::solve_part_2(),
        _ => {
            eprintln!("Missing solution for given day/part");
        }
    }
}
