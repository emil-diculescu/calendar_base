// Mocks generated by Mockito 5.4.4 from annotations
// in calendar_base/test/calendar_base_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

import 'calendar_base_test.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeWidget_0 extends _i1.SmartFake implements _i2.Widget {
  _FakeWidget_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );

  @override
  String toString({_i2.DiagnosticLevel? minLevel = _i2.DiagnosticLevel.info}) =>
      super.toString();
}

/// A class which mocks [Builders].
///
/// See the documentation for Mockito's code generation for more information.
class MockBuilders extends _i1.Mock implements _i3.Builders {
  @override
  _i2.Widget dayBuilder(
    _i2.BuildContext? context,
    DateTime? date,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #dayBuilder,
          [
            context,
            date,
          ],
        ),
        returnValue: _FakeWidget_0(
          this,
          Invocation.method(
            #dayBuilder,
            [
              context,
              date,
            ],
          ),
        ),
        returnValueForMissingStub: _FakeWidget_0(
          this,
          Invocation.method(
            #dayBuilder,
            [
              context,
              date,
            ],
          ),
        ),
      ) as _i2.Widget);

  @override
  _i2.Widget weekNumberBuilder(
    _i2.BuildContext? context,
    int? weekNumber,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #weekNumberBuilder,
          [
            context,
            weekNumber,
          ],
        ),
        returnValue: _FakeWidget_0(
          this,
          Invocation.method(
            #weekNumberBuilder,
            [
              context,
              weekNumber,
            ],
          ),
        ),
        returnValueForMissingStub: _FakeWidget_0(
          this,
          Invocation.method(
            #weekNumberBuilder,
            [
              context,
              weekNumber,
            ],
          ),
        ),
      ) as _i2.Widget);

  @override
  _i2.Widget weekDayNameBuilder(
    _i2.BuildContext? context,
    String? weekDayName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #weekDayNameBuilder,
          [
            context,
            weekDayName,
          ],
        ),
        returnValue: _FakeWidget_0(
          this,
          Invocation.method(
            #weekDayNameBuilder,
            [
              context,
              weekDayName,
            ],
          ),
        ),
        returnValueForMissingStub: _FakeWidget_0(
          this,
          Invocation.method(
            #weekDayNameBuilder,
            [
              context,
              weekDayName,
            ],
          ),
        ),
      ) as _i2.Widget);

  @override
  _i2.Widget monthNameBuilder(
    _i2.BuildContext? context,
    DateTime? date,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #monthNameBuilder,
          [
            context,
            date,
          ],
        ),
        returnValue: _FakeWidget_0(
          this,
          Invocation.method(
            #monthNameBuilder,
            [
              context,
              date,
            ],
          ),
        ),
        returnValueForMissingStub: _FakeWidget_0(
          this,
          Invocation.method(
            #monthNameBuilder,
            [
              context,
              date,
            ],
          ),
        ),
      ) as _i2.Widget);
}
