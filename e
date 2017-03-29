
[1mFrom:[0m /usr/local/rvm/gems/ruby-2.3.0@bookstore1/gems/mail-2.6.4/lib/mail/fields/unstructured_field.rb @ line 46 Mail::UnstructuredField#initialize:

    [1;34m26[0m: [32mdef[0m [1;34minitialize[0m(name, value, charset = [1;36mnil[0m)
    [1;34m27[0m:   @errors = []
    [1;34m28[0m: 
    [1;34m29[0m:   [32mif[0m value.is_a?([1;34;4mArray[0m)
    [1;34m30[0m:     [1;34m# Probably has arrived here from a failed parse of an AddressList Field[0m
    [1;34m31[0m:     value = value.join([31m[1;31m'[0m[31m, [1;31m'[0m[31m[0m)
    [1;34m32[0m:   [32melse[0m
    [1;34m33[0m:     [1;34m# Ensure we are dealing with a string[0m
    [1;34m34[0m:     value = value.to_s
    [1;34m35[0m:   [32mend[0m
    [1;34m36[0m: 
    [1;34m37[0m:   [32mif[0m charset
    [1;34m38[0m:     [1;36mself[0m.charset = charset
    [1;34m39[0m:   [32melse[0m
    [1;34m40[0m:     [32mif[0m value.respond_to?([33m:encoding[0m)
    [1;34m41[0m:       [1;36mself[0m.charset = value.encoding
    [1;34m42[0m:     [32melse[0m
    [1;34m43[0m:       [1;36mself[0m.charset = [1;32m$KCODE[0m
    [1;34m44[0m:     [32mend[0m
    [1;34m45[0m:   [32mend[0m
 => [1;34m46[0m:   [1;36mself[0m.name = name
    [1;34m47[0m:   [1;36mself[0m.value = value
    [1;34m48[0m:   [1;36mself[0m
    [1;34m49[0m: [32mend[0m

