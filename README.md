# ARM Cortex-M3 Context Switching & Scheduler (Bare Metal)

A bare-metal ARM Cortex-M3 project that demonstrates how a CPU appears to run multiple tasks concurrently by switching between them and restoring their execution context.

The project is written entirely in ARM Assembly, runs on QEMU, and is debugged using GDB.

---

# Motivation

One question that often comes up while studying Operating Systems is:

> "A CPU can execute only one instruction at a time, so how does it appear to run multiple tasks simultaneously?"

The answer is **context switching**.

A CPU executes one task for a short period of time, saves its state, loads the state of another task, and continues execution from exactly where that task previously stopped.

This project demonstrates that mechanism at the lowest level.

---

# Concepts Demonstrated

- ARM Cortex-M3 Architecture 
- Bare Metal Programming
- Vector Table
- Reset Handler
- SysTick Timer
- Interrupt Handling
- Exception Entry and Exit
- Context Saving
- Context Restoration
- Task Stack Initialization
- Scheduler Fundamentals
- Round Robin Scheduling Concepts
- QEMU Emulation
- GDB Debugging

---

# Understanding The Problem

Imagine three tasks:

```text
Task 1
Task 2
Task 3
```

The CPU can only execute one task at a time.
What actually happens is:

```text
Task 1 -> Task 2 -> Task 3 -> Task 1 -> ...
```

The switching happens so quickly that it creates the illusion of concurrency.
For this to work, the CPU must remember:

- Program Counter (PC)
- Registers
- Stack Pointer (SP)
- Current execution state

for every task. 
---

# How Context Switching Works

Every task owns its own stack.

```text
Task 1 --> Stack 1
Task 2 --> Stack 2
Task 3 --> Stack 3
```

When an interrupt occurs:

1. CPU saves the current task context.
2. Scheduler decides the next task.
3. Stack Pointer is switched.
4. Context of the next task is restored.
5. CPU resumes execution of the selected task.

---

# Project Flow

```text
Reset
   |
   V
Reset Handler
   |
   V
Configure SysTick Timer
   |
   V
Periodic Interrupt
   |
   V
SysTick Handler
   |
   +--> Save Current Context
   |
   +--> Select Next Task
   |
   +--> Load Next Task Stack
   |
   +--> Restore Context
   |
   V
Resume Task Execution
```

---

# Reset Handler

The Reset Handler is the first piece of code executed after a reset.

Responsibilities:

- Initialize the system
- Configure hardware
- Set up execution environment
- Start the scheduler

Without a Reset Handler, execution would begin with an undefined environment.

---

# SysTick Timer

The Cortex-M3 contains a built-in SysTick timer.

The timer periodically generates interrupts.

```text
SysTick Interrupt
        |
        V
Scheduler Runs
```

This interrupt acts as the heartbeat of the scheduler.

---

# Context Saved By Hardware

When an exception occurs, Cortex-M automatically saves:

```text
R0
R1
R2
R3
R12
LR
PC
xPSR
```

onto the stack.

---

# Context Saved By Software

The scheduler additionally saves:

```text
R4
R5
R6
R7
R8
R9
R10
R11
```

Together these form the complete task context.

---

# Task Stacks

The project creates three independent task stacks.

```text
Stack 1
Stack 2
Stack 3
```

Each stack contains:

- Initial register values
- Program Counter
- Link Register
- xPSR

This allows the scheduler to restore a task and begin execution immediately.

---

# Example Tasks

Three simple tasks are included:

## Task 1

```asm
main1:
    add r0, r0, #1
    b main1
```

## Task 2

```asm
main2:
    add r1, r1, #2
    b main2
```

## Task 3

```asm
main3:
    add r2, r2, #3
    b main3
```

Each task modifies a different register, making context restoration easy to observe in GDB.

---

# Exception Return

After restoring the selected task context:
is executed.

The Cortex-M hardware automatically:

- Restores saved registers
- Restores Program Counter
- Restores execution state

and continues execution of the selected task.

---

# Project Structure

```text
.
├── foo.S
├── map.ld
├── Makefile
└── README.md
```

---

# Requirements

Install:

## ARM GNU Toolchain

Provides:

```text
arm-none-eabi-as
arm-none-eabi-ld
arm-none-eabi-objdump
arm-none-eabi-readelf
```

---

## QEMU

Used to emulate the Cortex-M3 board.

Verify installation:

```bash
qemu-system-arm --version
```

---

## GDB Multiarch

Used for debugging.

Verify installation:

```bash
gdb-multiarch --version
```

---

# Build

```bash
make
```

---

# Run

Terminal 1:

```bash
make qemu
```

Terminal 2:

```bash
make gdb
```

---

# Useful GDB Commands

Breakpoints:

```gdb
b systick_handler
b magic
b main1
b main2
b main3
```

Continue:

```gdb
c
```

Single Step:

```gdb
si
```

Show Registers:

```gdb
info reg
```

Inspect Memory:

```gdb
x/16wx ADDRESS
```

Current Instruction:

```gdb
x/i $pc
```

---

# What I Learned

Although its a very crude implementation of scheduling in a cpu but it taught me how things really work also
Through this project I learned:

- How Cortex-M exceptions work
- How SysTick drives scheduling
- How CPUs switch between tasks
- Why each task needs its own stack
- How context saving and restoration works
- How exception return restores execution
- How schedulers form the foundation of operating systems
- How to debug bare-metal firmware using GDB and QEMU

---

# Future Improvements

- Fully Automatic Round-Robin Scheduler by manipulating the systick handler part
  which will enable it to store Current SP and choose next Stack Pointer.
---

# References

- ARM Cortex-M3 Technical Reference Manual (https://developer.arm.com/documentation/dui0552/a?lang=en )
- ARM Architecture Reference Manual ( https://developer.arm.com/documentation/dui0552/a?lang=en )
- QEMU Documentation
- GNU GDB Documentation
