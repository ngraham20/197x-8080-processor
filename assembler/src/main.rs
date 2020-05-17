use std::fs::File;
use std::io::{self, BufRead};
use std::collections::{HashMap, VecDeque};

enum Variable {
    Register(String),
    Uint16(u16),
}

type Labels = HashMap<String, u16>;
type Variables = HashMap<String, Variable>;


fn main() {
    let mut variables: Variables = HashMap::new();
    let mut labels: Labels = HashMap::new();

    parsefile(&mut variables, &mut labels);
}

fn parsefile(mut variables: &mut Variables, mut labels: &mut Labels) {
    // File hosts must exist in current path before this produces output
    // Consumes the iterator, returns an (Optional) String
    let lines = read_lines("main.sea");

    match parse_begin(&lines) {
        Ok(pos) => {
            parse_lables_pc(&lines, pos, &mut labels);

            parse_variables(&lines, pos, &mut variables);

            parse_instructions(&lines, pos, &labels, &variables);
        },
        Err(pos) => {
            println!("{}", pos);
        }
    }
}

fn read_lines(path: &str) -> Vec<std::result::Result<String, std::io::Error>> {

    let file = File::open(path).unwrap();
    let buffered = io::BufReader::new(file);

    buffered.lines().filter(|x| x.as_ref().unwrap() != "" && &x.as_ref().unwrap()[0..1] != "#" ).collect()
}

fn parse_begin(lines: &Vec<std::result::Result<std::string::String, std::io::Error>>) -> std::result::Result<usize, &str> {
    let pos = lines.iter().position(|x| x.as_ref().unwrap().to_uppercase() == "BEGIN");

    match pos {
        Some(val) => Ok(val),
        _ => Err("You forgot to add the BEGIN key... Bruh...")
    }
}

fn parse_lables_pc(lines: &Vec<std::result::Result<std::string::String, std::io::Error>>, pos: usize, labels: &mut Labels) {
    let mut pending_labels: VecDeque<String> = VecDeque::new();
    for (i, line) in lines[pos+1..].iter().enumerate() {
        if let Ok(instr) = line {
            let upinstr = instr.to_uppercase();
            let tokens: Vec<&str> = upinstr.split(" ").collect();
            match &tokens[0][0..1] {
                ":" => {
                    pending_labels.push_back(String::from(&tokens[0][1..]));
                },
                _ => {
                    let pc = ((i - labels.len() - pending_labels.len())) as u16;
                    while let Some(label) = pending_labels.pop_front() {
                        labels.insert(label, pc);
                    }
                }
            }
        }
    }
}

fn parse_variables(lines: & Vec<std::result::Result<std::string::String, std::io::Error>>, pos: usize, variables: &mut Variables) {
    for line in &lines[..pos] {
        if let Ok(instr) = line {
            let upinstr = instr.to_uppercase();
            let tokens: Vec<&str> = upinstr.split(" ").collect();
            match &tokens[0][..] {
                "VAR" => {
                    let vname = String::from(tokens[1]);
                    let vvalue = String::from(tokens[3]);
                    let v = match &tokens[2][..] {
                        "UINT16" => Ok(Variable::Uint16(vvalue.parse::<u16>().unwrap())),
                        "REG" => Ok(Variable::Register(vvalue)),
                        _ => Err("Invalid variable type, you dingus.")
                    };

                    variables.insert(vname, v.unwrap());
                    
                }
                _ => {Err("Invalid variable declaration, you dingus.").unwrap()}
            }
        }
    }
}

fn parse_instructions(lines: &Vec<std::result::Result<std::string::String, std::io::Error>>, pos: usize, labels: &Labels, variables: &Variables) {

    // [opcode] [src] [tgt] [dst]
    // [opcode] [src] [imm]


    for line in lines[pos+1..].iter().filter(|x| &x.as_ref().unwrap()[0..1] != ":" ) {
        let mut instcode: u32 = 0x00;
        if let Ok(instr) = line {
            let upinstr = instr.to_uppercase();
            let tokens: Vec<&str> = upinstr.split(" ").collect();
            match &tokens[0][..] {
                "ADD" => {
                    // instruction code is 0x00
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_register(&tokens[2], &variables).unwrap() as u32 * u32::pow(16, 2);
                    instcode += parse_register(&tokens[3], &variables).unwrap() as u32;
                },
                "SUB" => {
                    instcode += 0x01000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_register(&tokens[2], &variables).unwrap() as u32 * u32::pow(16, 2);
                    instcode += parse_register(&tokens[3], &variables).unwrap() as u32;
                },
                "MUL" => {
                    instcode += 0x02000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_register(&tokens[2], &variables).unwrap() as u32 * u32::pow(16, 2);
                    instcode += parse_register(&tokens[3], &variables).unwrap() as u32;
                },
                "AND" => {
                    instcode += 0x03000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_register(&tokens[2], &variables).unwrap() as u32 * u32::pow(16, 2);
                    instcode += parse_register(&tokens[3], &variables).unwrap() as u32;
                },
                "OR" => {
                    instcode += 0x04000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_register(&tokens[2], &variables).unwrap() as u32 * u32::pow(16, 2);
                    instcode += parse_register(&tokens[3], &variables).unwrap() as u32;
                },
                "XOR" => {
                    instcode += 0x05000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_register(&tokens[2], &variables).unwrap() as u32 * u32::pow(16, 2);
                    instcode += parse_register(&tokens[3], &variables).unwrap() as u32;
                },
                "SRR" => {
                    instcode += 0x06000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_register(&tokens[2], &variables).unwrap() as u32 * u32::pow(16, 2);
                    instcode += parse_register(&tokens[3], &variables).unwrap() as u32;
                },
                "SRL" => {
                    instcode += 0x07000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_register(&tokens[2], &variables).unwrap() as u32 * u32::pow(16, 2);
                    instcode += parse_register(&tokens[3], &variables).unwrap() as u32;
                },
                "SLT" => {
                    instcode += 0x08000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_register(&tokens[2], &variables).unwrap() as u32 * u32::pow(16, 2);
                    instcode += parse_register(&tokens[3], &variables).unwrap() as u32;
                
                },
                "SEQ" => {
                    instcode += 0x09000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_register(&tokens[2], &variables).unwrap() as u32 * u32::pow(16, 2);
                    instcode += parse_register(&tokens[3], &variables).unwrap() as u32;
                },
                "COPY" => {
                    instcode += 0x0A000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_register(&tokens[2], &variables).unwrap() as u32 * u32::pow(16, 2);
                },
                "ADDI" => {
                    instcode += 0xFF000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_immediate(&tokens[2], &variables, &labels).unwrap() as u32;
                },
                "SUBI" => {
                    instcode += 0xFE000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_immediate(&tokens[2], &variables, &labels).unwrap() as u32;
                },
                "COPI" => {
                    instcode += 0xFD000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_immediate(&tokens[2], &variables, &labels).unwrap() as u32;
                },
                "JUMP" => {
                    instcode += 0xE0000000;
                    instcode += parse_immediate(&tokens[1], &variables, &labels).unwrap() as u32 * 4;
                },
                "TJMP" => {
                    instcode += 0xFC000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_immediate(&tokens[2], &variables, &labels).unwrap() as u32 * 4;
                },
                "FJMP" => {
                    instcode += 0xFB000000;
                    instcode += parse_register(&tokens[1], &variables).unwrap() as u32 * u32::pow(16, 4);
                    instcode += parse_immediate(&tokens[2], &variables, &labels).unwrap() as u32 * 4;
                },
                _ => {}
            };
        }
        println!("{:08x}", instcode);
    }
}

fn parse_register<'a>(token: &'a str, variables: &'a Variables) -> std::result::Result<u8, &'a str> {
    let bytetoken: Result<&[u8], &str>;
    if let Some(var) = variables.get(token) {
        bytetoken = match var {
            Variable::Register(val) => Ok(val.as_bytes()),
            _ => Err("Variable specified is not a register, you scrub."),
        };
    } else {
        bytetoken = Ok(token.as_bytes());
    }
    let registeroffset: u8 = 0x20;
    let register = match bytetoken.unwrap()[0] as char {
        'R' => Ok(0x00 + registeroffset),
        'A' => Ok(0x00 + registeroffset),
        'B' => Ok(0x08 + registeroffset),
        'C' => Ok(0x10 + registeroffset),
        'D' => Ok(0x18 + registeroffset),
        _ =>   Err("Invalid register, you scrub.")
    };

    let offset = match bytetoken.unwrap()[1..].into_iter().map(|x| *x as char).collect::<String>().as_str() {
        "0" => Ok(0x00),
        "1" => Ok(0x01),
        "2" => Ok(0x02),
        "3" => Ok(0x03),
        "4" => Ok(0x04),
        "5" => Ok(0x05),
        "6" => Ok(0x06),
        "7" => Ok(0x07),
        _ => Err("Invalid offset, you scrub.")
    };

    match (register, offset) {
        (Ok(r), Ok(o)) => Ok(r + o),
        (Ok(_), Err(o)) => Err(o),
        (Err(r), Ok(_)) => Err(r),
        _ => Err("This whole register token is shot, you monster.")
    }
}

fn parse_immediate<'a>(token: &'a str, variables: &'a Variables, labels: &'a Labels) -> std::result::Result<u16, &'a str> {
    let result: Result<u16, &str>;
    if let Some(var) = variables.get(token) {
        result = match var {
            Variable::Uint16(val) => Ok(*val),
            _ => Err("Variable specified is not a Uint16, you scrub.")
        };
    } else if let Some(label) = labels.get(token) {
        result = Ok(*label);
    } else {
        result = match token.parse::<u16>() {
            Ok(ok) => Ok(ok),
            Err(_) => Err("Invalid immidate value, you scrub.")
        };
    }

    result
}