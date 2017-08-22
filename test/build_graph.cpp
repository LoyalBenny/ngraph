// ----------------------------------------------------------------------------
// Copyright 2017 Nervana Systems Inc.
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// ----------------------------------------------------------------------------

#include "values/type.hpp"
#include "values/function.hpp"

using namespace std;
using namespace ngraph;

void build_simple_graph()
{
    // Function with 4 parameters
    auto cluster_0 = make_shared<Function>(4);
    cluster_0->result()->type(element_type_float, Shape {32, 3});
    cluster_0->parameter(0)->type(element_type_float, Shape {Shape {7, 3}});
    cluster_0->parameter(1)->type(element_type_float, Shape {Shape {3}});
    cluster_0->parameter(2)->type(element_type_float, Shape {Shape {32, 7}});
    cluster_0->parameter(3)->type(element_type_float, Shape {Shape {32, 7}});
    auto arg3 = cluster_0->parameter(3);
    // call broadcast op on arg3, broadcasting on axis 1.
    //auto broadcast_1 = op::broadcast(arg3, 1);
    auto arg2 = cluster_0->parameter(2);
    auto arg0 = cluster_0->parameter(0);
    // call dot op
    //auto dot = op::dot(arg2, arg0);
    // Function returns tuple of dot and broadcast_1.
    //cluster_0.result->value(op::tuple(dot, broadcast_1));
}
