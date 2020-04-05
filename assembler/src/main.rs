use std::fs::File;
use std::io::{self, BufRead};
use std::collections::HashMap;

enum Variable {
    uint16(u16),
}

type Labels = HashMap<String, u16>;
type Variables = HashMap<String, Variable>;


fn main() {
    let mut variables: Variables = HashMap::new();
    let mut labels: Labels = HashMap::new();

    parsefile(&mut variables, &mut labels);
}

fn parsefile(mut variables: &mut Variables, mut lables: &mut Labels) {
    // File hosts must exist in current path before this produces output
    // Consumes the iterator, returns an (Optional) String
    let lines = read_lines("test.sea");

    match parse_begin(&lines) {
        Ok(pos) => {
            parse_variables(&lines, pos, &mut variables);

            parse_instructions(&lines, pos, &lables, &variables);
        },
        Err(pos) => {
            println!("{}", pos);
        }
    }
}

fn read_lines(path: &str) -> Vec<std::result::Result<String, std::io::Error>> {

    let file = File::open(path).unwrap();
    let buffered = io::BufReader::new(file);

    buffered.lines().collect()
}

fn parse_begin(lines: &Vec<std::result::Result<std::string::String, std::io::Error>>) -> std::result::Result<usize, &str> {
    let pos = lines.iter().position(|x| x.as_ref().unwrap().to_uppercase() == "BEGIN");

    match pos {
        Some(val) => Ok(val),
        _ => Err("You forgot to add the BEGIN key... Bruh...")
    }
}

fn parse_lables(lines: &Vec<std::result::Result<std::string::String, std::io::Error>>, lables: &mut Labels) {

    
}

fn parse_variables(lines: &Vec<std::result::Result<std::string::String, std::io::Error>>, pos: usize, variables: &mut Variables) {
    for line in &lines[..pos] {
        if let Ok(instr) = line {
            let upinstr = instr.to_uppercase();
            let tokens: Vec<&str> = upinstr.split(" ").collect();
            match &tokens[0][..] {
                "VAR" => {
                    let vname = String::from(tokens[1]);
                    let vvalue = String::from(tokens[3]);
                    let v = match &tokens[2][..] {
                        "UINT16" => Ok(Variable::uint16(vvalue.parse::<u16>().unwrap())),
                        _ => Err("Invalid variable type, you dingus.")
                    };

                    variables.insert(vname, v.unwrap());
                    
                }
                _ => {}
            }
        }
    }
}

fn parse_instructions(lines: &Vec<std::result::Result<std::string::String, std::io::Error>>, pos: usize, lables: &Labels, variables: &Variables) {
    for line in &lines[pos+1..] {
        let mut instcode: u32 = 0x00;
        if let Ok(instr) = line {
            let upinstr = instr.to_uppercase();
            let tokens: Vec<&str> = upinstr.split(" ").collect();
            match &tokens[0][..] {
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
                    instcode += parse_immediate(&tokens[2], &variables).unwrap() as u32;
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

fn parse_immediate<'a>(token: &'a str, variables: &'a Variables) -> std::result::Result<u16, &'a str> {

    let result: Result<u16, &str>;
    if let Some(var) = variables.get(token) {
        result = match var {
            Variable::uint16(val) => Ok(*val),
            _ => Err("No,  you noob")
        };
    } else {
        result = match token.parse::<u16>() {
            Ok(ok) => Ok(ok),
            Err(_) => Err("Invalid immidate value, you scrub.")
        };
    }

    match result {
        Ok(ok) => Ok(ok),
        Err(_) => Err("Invalid immediate value, you scrub.")
    }

}