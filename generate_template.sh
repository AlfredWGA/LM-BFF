python tools/generate_template.py \
    --output_dir my_auto_template \
    --task_name ocnli \
    --seed 13 \
    --beam 50 \
    --t5_model uer/t5-base-chinese-cluecorpussmall \
    # 中文 T5 的 beam 可以设大一点，因为会生成很多重复的模板
    # --t5_model google/mt5-base \
    # --beam 30
    # --task_name tnews \
    # --task_name eprstmt \