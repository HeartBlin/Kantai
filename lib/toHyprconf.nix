# https://github.com/nix-community/home-manager/blob/master/modules/lib/generators.nix
#
# MIT License
#
# Copyright (c) 2017-2026 Home Manager contributors
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
{ lib }:

let
  toHyprconf = { attrs, indentLevel ? 0, importantPrefixes ? [ "$" ] }: let
    inherit
      (lib)
      all
      concatMapStringsSep
      concatStrings
      concatStringsSep
      filterAttrs
      foldl
      generators
      hasPrefix
      isAttrs
      isList
      mapAttrsToList
      replicate
      attrNames
      ;

    initialIndent = concatStrings (replicate indentLevel "  ");

    toHyprconf' = indent: attrs: let
      isImportantField = n: _:
        foldl (acc: prev:
          if hasPrefix prev n
          then true
          else acc)
        false
        importantPrefixes;
      importantFields = filterAttrs isImportantField attrs;
      withoutImportantFields = fields: removeAttrs fields (attrNames importantFields);

      allSections = filterAttrs (_n: v: isAttrs v || isList v) attrs;
      sections = withoutImportantFields allSections;

      mkSection = n: attrs:
        if isList attrs
        then let
          separator =
            if all isAttrs attrs
            then "\n"
            else "";
        in (concatMapStringsSep separator (a: mkSection n a) attrs)
        else if isAttrs attrs
        then ''
          ${indent}${n} {
          ${toHyprconf' "  ${indent}" attrs}${indent}}
        ''
        else toHyprconf' indent { ${n} = attrs; };

      mkFields = generators.toKeyValue {
        listsAsDuplicateKeys = true;
        inherit indent;
      };

      allFields = filterAttrs (_n: v: !(isAttrs v || isList v)) attrs;
      fields = withoutImportantFields allFields;
    in
      mkFields importantFields
      + concatStringsSep "\n" (mapAttrsToList mkSection sections)
      + mkFields fields;
  in
    toHyprconf' initialIndent attrs;
in {
  inherit toHyprconf;
}
