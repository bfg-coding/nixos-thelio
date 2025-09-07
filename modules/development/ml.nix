# modules/development/ml.nix - Minimal AI/ML system dependencies
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Essential CUDA/GPU tools (system-wide makes sense)
    nvtopPackages.nvidia

    # Local AI TUI
    oterm

    # Git LFS for model files (useful across all projects)
    git-lfs

    # Audio tools for voice projects (system dependencies)
    ffmpeg
    portaudio
    alsa-lib

    # System monitoring for ML workloads
    btop
    iotop

    # Add PyTorch for CUDA testing
    python3Packages.torch
  ];

  # ZSH environment variables (properly loaded in zsh sessions)
  programs.zsh.sessionVariables = {
    # CUDA paths (needed for all ML projects)
    CUDA_PATH = "${pkgs.cudatoolkit}";
    CUDA_ROOT = "${pkgs.cudatoolkit}";

    # Ollama settings
    OLLAMA_HOST = "127.0.0.1:11434";
    OLLAMA_MODELS = "${config.home.homeDirectory}/.ollama/models";
    OLLAMA_GPU_ENABLED = "1";

    # HuggingFace cache (shared across projects efficiently)
    HF_HOME = "${config.home.homeDirectory}/.cache/huggingface";
  };

  # Additional zsh environment setup
  programs.zsh.envExtra = ''
    # Ensure CUDA libraries are always available
    export CUDA_VISIBLE_DEVICES=0
    
    # Add CUDA to library path if not already there
    if [[ ":$LD_LIBRARY_PATH:" != *":${pkgs.cudatoolkit}/lib:"* ]]; then
      export LD_LIBRARY_PATH="${pkgs.cudatoolkit}/lib:${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH"
    fi
  '';

  # Simple Ollama management scripts
  home.file.".local/bin/ollama-start" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      # Ensure CUDA environment is set
      export CUDA_PATH="${pkgs.cudatoolkit}"
      export CUDA_ROOT="${pkgs.cudatoolkit}"
      export LD_LIBRARY_PATH="${pkgs.cudatoolkit}/lib:${pkgs.linuxPackages.nvidia_x11}/lib:$LD_LIBRARY_PATH"
      export CUDA_VISIBLE_DEVICES=0
      export OLLAMA_GPU_ENABLED=1
      
      if ! pgrep -x "ollama" > /dev/null; then
        echo "Starting Ollama with GPU support..."
        nohup ollama serve > ~/.cache/ollama.log 2>&1 &
        sleep 2
        echo "Ollama started (logs: ~/.cache/ollama.log)"
        echo "GPU: $(nvidia-smi --query-gpu=name --format=csv,noheader,nounits 2>/dev/null || echo 'Detection failed')"
      else
        echo "Ollama already running"
      fi
    '';
  };

  home.file.".local/bin/ollama-stop" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      if pgrep -x "ollama" > /dev/null; then
        pkill -x ollama
        echo "Ollama stopped"
      else
        echo "Ollama not running"
      fi
    '';
  };

  # GPU debugging script
  home.file.".local/bin/gpu-debug" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      echo "🔍 GPU Debug Information"
      echo "========================"
      echo ""
      
      echo "📊 GPU Status:"
      nvidia-smi --query-gpu=name,memory.total,memory.used,temperature.gpu --format=csv,noheader,nounits
      echo ""
      
      echo "🔧 CUDA Environment:"
      echo "CUDA_PATH: $CUDA_PATH"
      echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"
      echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"
      echo ""
      
      echo "🤖 Ollama Status:"
      if pgrep -x "ollama" > /dev/null; then
        echo "✅ Ollama running"
        ollama list 2>/dev/null || echo "❌ Ollama API not responding"
        echo ""
        echo "📝 Current models:"
        ollama ps 2>/dev/null || echo "❌ Cannot get model status"
      else
        echo "❌ Ollama not running"
      fi
      
      echo ""
      echo "💡 Quick fixes:"
      echo "- ollama-stop && ollama-start (restart with CUDA)"
      echo "- nrs (rebuild NixOS config)"
      echo "- Check logs: tail -f ~/.cache/ollama.log"
    '';
  };


  home.file.".local/bin/test-ai" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      echo "🔍 Testing AI setup..."
      echo "GPU: $(nvidia-smi --query-gpu=name --format=csv,noheader,nounits 2>/dev/null)"
    
      # Test CUDA
      python3 -c "import torch; print('CUDA:', '✅' if torch.cuda.is_available() else '❌')" 2>/dev/null || echo "CUDA: ❌ (PyTorch not available)"
    
      # Test Ollama
      if systemctl is-active --quiet ollama; then
        echo "Ollama: ✅ Service running"
      else
        echo "Ollama: ❌ Service not running"
      fi
    '';
  };
  # Useful aliases
  programs.zsh.shellAliases = {
    "gpu-status" = "nvidia-smi";
    "gpu-watch" = "watch -n 1 nvidia-smi";
    "gpu-debug" = "gpu-debug";
    "ollama-chat" = "ollama run llama3.2";
    "ml-monitor" = "nvtop";
    "gpu-temp" = "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits";
    "ai-models" = "ollama list && echo '=== Currently Loaded ===' && ollama ps";
  };
}
