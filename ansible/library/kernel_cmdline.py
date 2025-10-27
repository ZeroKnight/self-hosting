#!/usr/bin/python

from ansible.module_utils.basic import AnsibleModule, tempfile

KERNEL_CMDLINE_FILE = "/etc/kernel/cmdline"


def make_cmdline(parameters: dict[str, str]) -> str:
    return " ".join(f"{p}={v}" if v is not None else p for p, v in parameters.items())


def main() -> None:
    module = AnsibleModule(
        argument_spec={
            "parameter": {"type": "str", "required": True},
            "value": {"type": "str", "required": False},
            "state": {"type": "str", "required": False, "default": "present", "choices": ("present", "absent")},
        },
        supports_check_mode=True,
    )
    changed = False

    kernel_parameters = {}
    with open(KERNEL_CMDLINE_FILE) as file:
        for param in file.read().split():
            # Partition correctly handles parameters like ZFS roots, e.g.
            # root=ZFS=/rpool/ROOT
            key, _, value = param.partition("=")
            kernel_parameters[key] = value or None

    parameter = module.params["parameter"]
    value = module.params.get("value")
    state = module.params["state"]

    cmdline_old = make_cmdline(kernel_parameters)
    if state == "present" and (parameter not in kernel_parameters or value != kernel_parameters.get(parameter)):
        kernel_parameters[parameter] = value
        changed = True
    elif state == "absent":
        try:
            del kernel_parameters[parameter]
        except KeyError:
            pass
        else:
            changed = True
    cmdline_new = make_cmdline(kernel_parameters)

    diff = {}
    if module._diff:
        diff["before"] = cmdline_old
        diff["after"] = cmdline_new

    if not module.check_mode:
        with tempfile.NamedTemporaryFile("w", delete=False) as tfile:
            tfile.write(f"{cmdline_new}\n")
            module.atomic_move(tfile.name, KERNEL_CMDLINE_FILE)

    module.exit_json(
        changed=changed,
        parameter=parameter,
        value=value,
        state=state,
        parameters=kernel_parameters,
        cmdline=cmdline_new,
        diff=diff,
    )


if __name__ == "__main__":
    main()
