use std::{error::Error, io::Read};

pub fn solve_part_1() {
    match read_input(&mut std::io::stdin()) {
        Ok(values) => println!("{:?}", count_increases(values)),
        Err(err) => println!("Could not read input: {:?}", err),
    }
}

pub fn solve_part_2() {
    match read_input(&mut std::io::stdin()) {
        Ok(values) => println!("{:?}", count_sliding_window_increases(values)),
        Err(err) => println!("Could not read input: {:?}", err),
    }
}

/// Reads the input from the given input stream. It expects a string of multiple
/// lines with integers.
fn read_input(reader: &mut impl Read) -> Result<Vec<u32>, Box<dyn Error>> {
    let mut buffer = String::new();

    reader.read_to_string(&mut buffer)?;
    buffer.trim().lines().map(|l| Ok(l.parse()?)).collect()
}

/// Counts the number of increases compared to the previous value in the given
/// vector.
fn count_increases(values: Vec<u32>) -> u32 {
    if values.is_empty() {
        return 0;
    }

    let mut increases = 0;
    let mut last_value = values.first().unwrap();

    for value in values.iter().skip(1) {
        if value > last_value {
            increases += 1;
        }
        last_value = value;
    }

    increases
}

/// Counts the increases of the sum of values in a sliding window with three
/// measurements with the previous window.
fn count_sliding_window_increases(values: Vec<u32>) -> u32 {
    if values.is_empty() {
        return 0;
    }

    let mut increases = 0;
    let mut last_value = *values.first().unwrap();

    for (i, value) in values.iter().enumerate() {
        if i >= values.len() - 3 {
            break;
        }
        let window_value = *value + values[i + 1] + values[i + 2];
        if window_value > last_value {
            increases += 1;
        }
        last_value = window_value;
    }

    increases
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn reads_and_parses_example_input() {
        let input = "199
200
208
210
200
207
240
269
260
263
";
        let values = read_input(&mut input.as_bytes()).unwrap();
        assert_eq!(
            values,
            vec![199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
        );
    }

    #[test]
    fn reads_and_parses_empty_input() {
        let input = "";
        let result = read_input(&mut input.as_bytes()).unwrap();
        assert_eq!(result, vec![]);
    }

    #[test]
    fn count_increases_with_example_values() {
        let values = vec![199, 200, 208, 210, 200, 207, 240, 269, 260, 263];
        let result = count_increases(values);
        assert_eq!(result, 7);
    }

    #[test]
    fn count_increases_with_empty_values() {
        let values = vec![];
        let result = count_increases(values);
        assert_eq!(result, 0);
    }

    #[test]
    fn count_sliding_window_increases_with_example_values() {
        let values = vec![199, 200, 208, 210, 200, 207, 240, 269, 260, 263];
        let result = count_sliding_window_increases(values);
        assert_eq!(result, 5);
    }

    #[test]
    fn count_sliding_window_increases_with_empty_values() {
        let values = vec![];
        let result = count_sliding_window_increases(values);
        assert_eq!(result, 0);
    }
}
