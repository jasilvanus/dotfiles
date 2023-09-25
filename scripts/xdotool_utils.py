#!/usr/bin/env python3

"""
    This module is essentially a wrapper around xdotools,
    extending its features by some convenience methods.

    In particular, it provides a way to toggle active/minimized
    state of a window, intended for nice key bindings.
"""

import argparse
import subprocess
import time

def get_args():
    parser = argparse.ArgumentParser()

    # Potentially add other identifiers later, e.g. process name or PID
    window_identifier_group_container = parser.add_argument_group("Target window identification")
    window_identifier_group = window_identifier_group_container.add_mutually_exclusive_group(required=True)
    window_identifier_group.add_argument("--name", "-n",
                                         help="Name of the window to switch to.")

    action_group_container = parser.add_argument_group("Actions")
    action_group = action_group_container.add_mutually_exclusive_group()
    action_group.add_argument("--activate", "-a", action="store_true", help="Activate the window.")
    action_group.add_argument("--minimize", "-m", action="store_true", help="Minimize the window.")
    action_group.add_argument("--toggle-active-minimized", "-tam", action="store_true",
                              help="Toggle between active and minimized.")

    parser.add_argument("--verbose", "-v", action="store_true")
    parser.add_argument("--accept-multi-matches", "-amm", action="store_true",
                        help="If a name search yields multiple results, we normally abort."
                        "With this flag, we instead apply the result to all matches.")
    parser.add_argument("--delay-exit", "-de", action="store_true",
                        help="Delay exiting the process by a few milliseconds. Useful when "
                        "binding this in KDE which chokes on processes finishing too quickly when trying to apply cgroup settings.")
    return parser.parse_args()

def run_xdotool(cmd, window_id=None, verbose=False):
    cmd = f"xdotool {cmd}"
    if window_id is not None:
        cmd += f" {window_id}"
    if verbose:
        print(f"Running command: \"{cmd}\"")
    try:
        return subprocess.check_output(cmd, shell=True)
    except:
        print(f"Cmd {cmd} failed.")
        raise

def get_active_window_id(verbose=False):
    result = run_xdotool("getactivewindow", "", verbose=verbose)
    try:
        return int(result)
    except:
        print(f"Failed to aquire window id. Result: {result}.")
        raise RuntimeError(result)

def get_window_ids_by_name(name, verbose=False):
    cmd = f"xdotool search --name \"{name}\""
    if verbose:
        print(f"Running command: \"{cmd}\"")
    try:
        result = subprocess.check_output(cmd, shell=True)
    except:
        print(f"Cmd failed: \"{cmd}\"")
        raise
    try:
        decoded_result = result.decode()
        return [int(line) for line in decoded_result.split("\n") if line]
    except:
        print(f"Failed to aquire window id. Command: {cmd}, result: {result}.")
        raise RuntimeError(result)

def run_activate(window_id, verbose=False):
    run_xdotool("windowactivate", window_id, verbose=verbose)

def run_minimize(window_id, verbose=False):
    run_xdotool("windowminimize", window_id, verbose=verbose)

def run_toggle_active_minimized(window_id, verbose=False):
    active_window_id = get_active_window_id(verbose=verbose)
    if verbose:
        print(f"Active window: {active_window_id}, target window: {window_id}")
    if active_window_id == window_id:
        run_minimize(window_id, verbose=verbose)
    else:
        run_activate(window_id, verbose=verbose)

def run_with_window_id(args, target_window_id):
    if args.activate:
        run_activate(target_window_id)
    elif args.minimize:
        run_minimize(target_window_id)
    elif args.toggle_active_minimized:
        run_toggle_active_minimized(target_window_id, verbose=args.verbose)

def run(args):
    target_window_ids = get_window_ids_by_name(args.name, args.verbose)
    if len(target_window_ids) == 0:
        raise RuntimeError(f"Failed to find any window with given name")
    elif len(target_window_ids) == 1:
        run_with_window_id(args, target_window_ids[0])
    else:
        if args.accept_multi_matches:
            for wid in target_window_ids:
                run_with_window_id(args, wid)
        else:
            raise RuntimeError(f"Name match returned multiple results. Refine or use --accept_multi_matches.")
    if args.delay_exit:
        time.sleep(0.1)

def _main():
    args = get_args()
    run(args)

if __name__ == "__main__":
    _main()
