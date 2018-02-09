/* Copyright 2017 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * 	http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <inttypes.h>

#define REG_MEM -3
#define REG_MSR -2
#define REG_NIA -1
#define REG_R31 31

int putprocreg(struct pdbg_target *target, uint32_t index, uint64_t *reg, uint64_t *value);
int getprocreg(struct pdbg_target *target, uint32_t index, uint64_t *reg, uint64_t *unused);