use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    parsefile();
}

fn preparse() {
    // Parse comments
    // Parse labels
}

fn parsefile() {
    // File hosts must exist in current path before this produces output
    if let Ok(lines) = read_lines("./test.sea") {
        // Consumes the iterator, returns an (Optional) String
        for line in lines {
            let mut instcode: u32 = 0x00;
            if let Ok(instr) = line {
                let upinstr = instr.to_uppercase();
                let tokens: Vec<&str> = upinstr.split(" ").collect();
                match &tokens[0].to_uppercase()[..] {
                    "COPY" => {
                        instcode += 0xFE000000;
                        instcode += parse_register(&tokens[1]).unwrap() as u32 * u32::pow(16, 4);
                        instcode += parse_register(&tokens[2]).unwrap() as u32 * u32::pow(16, 2);
                    },
                    // "TJMP"  => {Ok(0xFD)},
                    // "JUMP" => {Ok(0xFC)},
                    "ADD" => {
                        // instruction code is 0x00
                        instcode += parse_register(&tokens[1]).unwrap() as u32 * u32::pow(16, 4);
                        instcode += parse_register(&tokens[2]).unwrap() as u32 * u32::pow(16, 2);
                        instcode += parse_register(&tokens[3]).unwrap() as u32;
                    },
                    "ADDI" => {
                        instcode += 0xFF000000;
                        instcode += parse_register(&tokens[1]).unwrap() as u32 * u32::pow(16, 4);
                        instcode += parse_immediate(&tokens[2]).unwrap() as u32;
                    },
                    "SLT" => {
                        instcode +=  0x03000000;
                        instcode+= parse_register(&tokens[1]).unwrap() as u32 * u32::pow(16, 4);
                        instcode+= parse_register(&tokens[2]).unwrap() as u32 * u32::pow(16, 2);
                    
                    },
                     "SEQ" => {
                         instcode += 0x02000000;
                         instcode+= parse_register(&tokens[1]).unwrap() as u32 * u32::pow(16, 4);
                         instcode+= parse_register(&tokens[2]).unwrap() as u32 * u32::pow(16, 2);
                        },
                     "AND" => {
                        instcode += 0x01000000;
                        instcode += parse_register(&tokens[1]).unwrap() as u32 * u32::pow(16,4);
                        instcode += parse_register(&tokens[2]).unwrap() as u32 * u32::pow(16,2);
                        instcode += parse_register(&tokens[3]).unwrap() as u32;
                    },
                    _ => {}
                };
            }
            println!("{:08X}", instcode);
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

fn parse_register(token: &str) -> std::result::Result<u8, &str> {
    let bytetoken = token.as_bytes();
    let register = match bytetoken[0] as char {
        'R' => Ok(0x00),
        'A' => Ok(0x02),
        'B' => Ok(0x18),
        'C' => Ok(0x34),
        _ =>   Err("Invalid register, you scrub.")
    };

    let offset = match bytetoken[1] as char {
        '0' => Ok(0x00),
        '1' => Ok(0x01),
        '2' => Ok(0x02),
        '3' => Ok(0x03),
        '4' => Ok(0x04),
        '5' => Ok(0x05),
        '6' => Ok(0x06),
        '7' => Ok(0x06),
        _ => Err("Invalid offset, you scrub.")
    };

    match (register, offset) {
        (Ok(r), Ok(o)) => Ok(r + o),
        (Ok(r), Err(o)) => Err(o),
        (Err(r), Ok(o)) => Err(r),
        _ => Err("This whole token is shot, you monster.")
    }
}

fn parse_immediate(token: &str) -> std::result::Result<u16, &str> {
    let result = token.parse::<u16>();

    match result {
        Ok(ok) => Ok(ok),
        Err(_) => Err("Invalid immediate value, you scrub.")
    }

}

// fn copy(instr: &str, sr: &str, ds: &str) -> std::result::Result<u32, &str> {
//     Ok(0x00)
// }

// fn tjmp(t0: bool, label: u16) -> std::result::Result<u32, &str> {
//     Ok(0x00)
// }

// fn jump(label: u16) -> std::result::Result<u32, &str> {
//     Ok(0x00)
// }

// fn add(sr: u8, tr: u8, ds: u8)  -> std::result::Result<u32, &str> {
//     Ok(0x00)
// }

// fn addi(sr: u8, imm: u16) -> std::result::Result<u32, &str> {
//     Ok(0x00)
// }

// fn slt(sr: u8, tr: u8) -> std::result::Result<u32, &str> {
//     Ok(0x00)
// }

// fn seq(sr: u8, tr: u8)  -> std::result::Result<u32, &str> {
//     Ok(0x00)
// }

// fn and(sr: u8, tr: u8, ds: u8) -> std::result::Result<u32, &str>{
//     Ok(0x00)
// }

