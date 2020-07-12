# Overview

This is a plugin for Vim that provides a set of [operators](http://vimdoc.sourceforge.net/htmldoc/motion.html#operator) to manipulate line units: splitting a single line into natural language sentence lines or otherwise on an arbitrary regular expression, or joining them with various delimiters (or no delimiter at all).

# Operators

## ``J``: Join Lines

Vim, by default, provides a [``J`` key-mapping](http://vimdoc.sourceforge.net/htmldoc/change.html#J) (or ``<Shift-J>``, represented as ``<S-j>`` in Vim) that joins lines into a single line.
This plugin overrides this mapping to transform this key into an [operator](http://vimdoc.sourceforge.net/htmldoc/motion.html#operator), i.e. one that takes a motion as well as count.
This means that in addition to applying ``J`` to a visual selection to join all the lines into a single line, you can provide a motion to specify the region of text to be join.
For e.g.:

-   ``J6j``
    Join this and the next 6 lines into a single line.
-   ``J3k``
    Join this and the previous 3 lines into a single line.
-   ``J/fin``
    Join all text from the current location to the occurrence of the string "fin" into a single line.

A special mapping, ``<S-j><S-j>`` (or "JJ") joins the current contiguous block of text into a single line, as a counterpart to ``<C-j><C-j>`` below.
So, ``<C-j><C-j>`` and ``<S-j><S-j>`` will in effect "toggle" a block of text into separate lines and back into a block again.

## ``gJ``: Join Lines with Delimiter

As above, but you will be prompted to enter a string that will inserted between the joined lines.
If you enter nothing (just hit ``<CR>`` or ``<ESC>`` at the prompt), you will replicate the native Vim ``gJ`` operation, i.e. join lines without spaces.

## ``<C-j>``: Split Text to Separate Lines By Sentence

As a counterpart to ``<S-j>``, this plugin also provides ``<C-j>``, or "Control+J".
This is an operator that splits a region of text specified by a count, motion, or visual selection into separate lines, with each sentence getting its own line.
A "sentence" in this context is a natural language sentence, not just a string ending in a period.
As this is an operator, you can provide counts and motions, e.g.:

-   ``<C-j>ip``
    Split out all sentences in this "paragraph" (block of contiguous lines) into separate lines.
-   ``<C-j>2j``
    Split out all sentences in this and the next two lines into separate lines.
-   ``<C-j>8k``
    Split out all sentences in this previous 8 lines into separate lines.

In addition ``<C-j><C-j>`` will apply the operation to just the current line, while with a visual selection active, just ``<C-j>`` by itself will apply the operation to the selection.

## ``<M-j>``: Split Text to Separate Lines On Expression

As above, but you will be prompted to enter an expression that will be used to identify the end of line units.
If you enter nothing (just hit ``<CR>`` or ``<ESC>`` at the prompt), the operation will be canceled.

# Acknowledgements

This plugin includes code and/or logic derived from:

-   [vim-sentence-chopper](https://github.com/Konfekt/vim-sentence-chopper).
