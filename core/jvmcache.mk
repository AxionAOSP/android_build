#
# Copyright (C) 2025-2026 AxionOS
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Disabled by default for faster Java and Kotlin compilation
# Set USE_JVMCACHE=true or USE_JVMCACHE=1 to enable.

ifneq ($(filter true 1,$(USE_JVMCACHE)),)
  # Dynamically discover jvmcache toolchain
  ifndef JVMCACHE_BIN_DIR
    ifneq ($(wildcard $(TOPDIR)prebuilts/jvmcache/linux-x86/bin/javac),)
      JVMCACHE_BIN_DIR := $(TOPDIR)prebuilts/jvmcache/linux-x86/bin
    else ifneq ($(wildcard $(TOPDIR)prebuilts/build-tools/linux-x86/bin/jvmcache),)
      JVMCACHE_BIN_DIR := $(TOPDIR)prebuilts/build-tools/linux-x86/bin
    else ifneq ($(wildcard $(TOPDIR)jvmcache/bin/javac),)
      JVMCACHE_BIN_DIR := $(TOPDIR)jvmcache/bin
    else ifneq ($(wildcard $(TOPDIR)../jvmcache/bin/javac),)
      JVMCACHE_BIN_DIR := $(abspath $(TOPDIR)../jvmcache/bin)
    else ifneq ($(wildcard $(HOME)/.local/bin/javac),)
      JVMCACHE_BIN_DIR := $(HOME)/.local/bin
    else ifneq ($(wildcard $(shell which jvmcache 2>/dev/null)),)
      JVMCACHE_BIN_DIR := $(dir $(shell which jvmcache 2>/dev/null))
    endif
  endif

  ifneq ($(wildcard $(JVMCACHE_BIN_DIR)/javac),)
    # Set wrapper for Make rules without using obsolete export keyword
    ifndef JAVAC_WRAPPER
      JAVAC_WRAPPER := $(JVMCACHE_BIN_DIR)/javac
    endif

    ifndef JVMCACHE_DIR
      ifdef CCACHE_DIR
        JVMCACHE_DIR := $(patsubst %/ccache,%/.jvmcache,$(CCACHE_DIR))
      else ifneq ($(wildcard $(TOPDIR)../.jvmcache),)
        JVMCACHE_DIR := $(abspath $(TOPDIR)../.jvmcache)
      else ifdef HOME
        JVMCACHE_DIR := $(HOME)/.cache/jvmcache
      else ifdef OUT_DIR
        JVMCACHE_DIR := $(OUT_DIR)/.cache/jvmcache
      endif
    endif

    ifndef ALTERNATE_JAVAC
      ALTERNATE_JAVAC := $(JVMCACHE_BIN_DIR)/javac
    endif
    ifndef ALTERNATE_KOTLINC
      ALTERNATE_KOTLINC := $(JVMCACHE_BIN_DIR)/kotlinc
    endif
    ifndef ALTERNATE_KAPT
      ALTERNATE_KAPT := $(JVMCACHE_BIN_DIR)/kapt
    endif
    ifndef ALTERNATE_D8
      ALTERNATE_D8 := $(JVMCACHE_BIN_DIR)/d8
    endif
    ifndef ALTERNATE_R8
      ALTERNATE_R8 := $(JVMCACHE_BIN_DIR)/r8
    endif

    USE_JVMCACHE := true
  endif
endif
