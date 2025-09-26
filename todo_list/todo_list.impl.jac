impl Task.mark_done {
    self.done = True;
}

impl Task.get_hint {
    return generate_hint(self.description);
}
