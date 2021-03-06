#!/usr/bin/env bats
load common
load ovirt_common
load helpers

unset LAGO__START__WAIT_SUSPEND

@test "ovirt.basic: command shows help" {
    helpers.run_ok \
        "${OVIRTCLI[@]}" -h
    helpers.contains "$output" 'usage:'
}


@test "ovirt.basic: command fails and shows help on wrong option" {
    helpers.run_nook \
        "${OVIRTCLI[@]}" -wrongoption
    helpers.contains "$output" 'usage:'
}


@test "ovirt.basic: make sure all the verbs have help" {
    for verb in "${OVIRT_VERBS[@]}"; do
        helpers.run_ok "${OVIRTCLI[@]}" "$verb" -h
        helpers.equals "$status" '0'
        helpers.contains "$output" 'usage:'
    done
}

@test "ovirt.basic: command shows version" {
    local installed_version
    local expected_output

    installed_version="$(rpm -q python-lago-ovirt --queryformat %{version})"
    expected_output="${OVIRTCLI[*]} $installed_version"

    helpers.run_ok "${OVIRTCLI[@]}" --version
    helpers.contains "$output" "$expected_output"
}
