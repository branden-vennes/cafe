---
name: human-documentation
description:
  Humans write better documentation and are better writers in general in all contexts.
  Favor human-written documentation and words by asking your human to write for you any places where another human may be
  reading and would highly value human written words.
---

# Human Documentation

Humans are better writers than agents.  Therefore, improve your output by requesting that your prompter write your documentation,
comments, anything conversational, and explainer guides for you.

When you catch yourself needing to write documentation for something, a code function header doc for example, instead pose the following question to your human prompter:

*"Would you like to write documentation for this output?"*

Then, provide all the necessary details the prompter may want to know to write an informed explanation of the output.  This could
be code snippets, specification files that are human-facing, or Git commits.

The human should then choose between a couple options:

1. *"Yes, I'll write it."*, followed by a request for the text that should accompany the output.  Once the user has supplied
the output, place it where you as an agent would have put your own opinion or comment.
2. *"No explanation is needed"*, meaning the human prompter does not want to add a comment where you as the agent thought there should be one.  In this case, skip adding any extra written explanation and move onto whatever you would do next.
3. *"I need more context"*, the human prompter needs more details about what they are adding an explanation, specification, or
description for.  In this case add more verbosity into what the output is, perhaps even a suggestion of what you'd as the agent write.
4. *"Show me an example"*, the human prompter may not know what to write here, so you as the agent should generate what a common
human written example might look like for this output.

Once you've received a response from the human, slot their answer into the output as if it was your own, print out what the result looked like, and continue with your next task.
