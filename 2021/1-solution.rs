use std::fs;


fn count_increases(contents: &String) -> i32{
        let mut count = 0;
        let mut last_num = 0;
        contents.lines().for_each(|line| {
            let num = line.parse::<i32>().unwrap();
            if last_num == 0{
                last_num = num;
                return;
            }
            if num > last_num{
                count += 1
            }
            last_num = num;
        });
        return count
}

fn sum_count_increases(contents: &String) -> i32{
    let mut window : (i32, i32, i32) = (0,0,0);
    let mut last_sum = 0;
    let mut count = 0;
    contents.lines().for_each(|line|{
        let num = line.parse::<i32>().unwrap();
        window.0 = window.1;
        window.1 = window.2;
        window.2 = num;
        let sum = window.0 + window.1 + window.2;
        if window.0 == 0 || window.1 == 0 || window.2 == 0{
            return;
        }
        if sum > last_sum && last_sum > 0{
            count += 1;
        }
        last_sum = sum;
    });
    return count
}

fn main(){
    // Part 1
    let test_contents = fs::read_to_string("1-input-test.txt")
        .expect("Something went wrong reading the file");

    let mut count = count_increases(&test_contents);
    println!("Count for test input: {} expecting {}", count, 7);

    let sol_contents = fs::read_to_string("1-input.txt")
        .expect("Something went wrong reading the file");

    count = count_increases(&sol_contents);
    println!("Count for input: {}", count);

    // Part 2
    // check increases in the three measurement windows
    count = sum_count_increases(&test_contents);
    println!("Sum count for test input: {} expecting {}", count, 5);

    count = sum_count_increases(&sol_contents);
    println!("Sum count for input: {} expecting {}", count, 5);
    
}
