use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    parsefile();
}

fn parsefile() {
    // File hosts must exist in current path before this produces output
    if let Ok(lines) = read_lines("./test.asm") {
        // Consumes the iterator, returns an (Optional) String
        for line in lines {
            if let Ok(instr) = line {
                let tokens: Vec<&str> = instr.split(" ").collect();
                let opcode = match &tokens[0].to_ascii_uppercase()[..] {
                    "AND" => Ok(0x00),
                    "OR"  => Ok(0x01),
                    "ADDI" => Ok(0x02),
                    "SUBI" => Ok(0x03),
                    "COPY" => Ok(0x04),
                    _ => Err("Invalid Instruction")
                };
            }
        }
    }
}

// The output is wrapped in a Result to allow matching on errors
// Returns an Iterator to the Reader of the lines of the file.
fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

