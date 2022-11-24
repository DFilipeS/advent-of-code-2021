use std::{error::Error, io::Read};

#[derive(Debug, PartialEq)]
enum Command {
    Forward(u32),
    Up(u32),
    Down(u32),
}

pub fn solve_part_1() {
    match read_input(&mut std::io::stdin()) {
        Ok(commands) => {
            let (position, depth) = execute_commands(commands);
            println!("{}", position * depth);
        }
        Err(err) => println!("Could not read input: {:?}", err),
    }
}

pub fn solve_part_2() {
    match read_input(&mut std::io::stdin()) {
        Ok(commands) => {
            let (position, depth) = execute_aimed_commands(commands);
            println!("{}", position * depth);
        }
        Err(err) => println!("Could not read input: {:?}", err),
    }
}

fn read_input(reader: &mut impl Read) -> Result<Vec<Command>, Box<dyn Error>> {
    let mut buffer = String::new();
    reader.read_to_string(&mut buffer)?;

    buffer.trim().lines().map(parse_line).collect()
}

fn parse_line(line: &str) -> Result<Command, Box<dyn Error>> {
    let tokens: Vec<&str> = line.trim().split(' ').collect();
    let command_type = tokens.first().ok_or("missing command type")?;
    let value = tokens.get(1).ok_or("missing command value")?.parse()?;

    match *command_type {
        "forward" => Ok(Command::Forward(value)),
        "up" => Ok(Command::Up(value)),
        "down" => Ok(Command::Down(value)),
        _ => Err("invalid command".into()),
    }
}

fn execute_commands(commands: Vec<Command>) -> (u32, u32) {
    let mut position = 0;
    let mut depth = 0;

    for command in commands {
        match command {
            Command::Forward(value) => position += value,
            Command::Up(value) => depth -= value,
            Command::Down(value) => depth += value,
        }
    }

    (position, depth)
}

fn execute_aimed_commands(commands: Vec<Command>) -> (u32, u32) {
    let mut position = 0;
    let mut depth = 0;
    let mut aim = 0;

    for command in commands {
        match command {
            Command::Forward(value) => {
                position += value;
                depth += aim * value;
            }
            Command::Up(value) => aim -= value,
            Command::Down(value) => aim += value,
        }
    }

    (position, depth)
}

#[cfg(test)]
mod tests {
    use super::*;
    use Command::*;

    #[test]
    fn reads_and_parses_example_input() {
        let input = "forward 5
down 5
forward 8
up 3
down 8
forward 2
";
        let result = read_input(&mut input.as_bytes()).unwrap();
        assert_eq!(
            result,
            vec![Forward(5), Down(5), Forward(8), Up(3), Down(8), Forward(2)]
        );
    }

    #[test]
    fn reads_and_parses_empty_input() {
        let input = "";
        let result = read_input(&mut input.as_bytes()).unwrap();
        assert_eq!(result, vec![]);
    }

    #[test]
    fn execute_commands_with_example_input() {
        let values = vec![Forward(5), Down(5), Forward(8), Up(3), Down(8), Forward(2)];
        let result = execute_commands(values);
        assert_eq!(result, (15, 10));
    }

    #[test]
    fn execute_commands_with_empty_input() {
        let values = vec![];
        let result = execute_commands(values);
        assert_eq!(result, (0, 0));
    }

    #[test]
    fn execute_aimed_commands_with_example_input() {
        let values = vec![Forward(5), Down(5), Forward(8), Up(3), Down(8), Forward(2)];
        let result = execute_aimed_commands(values);
        assert_eq!(result, (15, 60));
    }
}
