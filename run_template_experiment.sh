# Run training & evaluation on training & dev set for each generated template
for template_id in {0..29}
do
    for seed in 13
    do
        # To save time, we fix these hyper-parameters

        # Since we only use dev performance here, use --no_predict to skip testing
        # TAG=exp-template \
        # TYPE=prompt \
        # TASK=eprstmt \
        # BS=$bs \
        # LR=$lr \
        # SEED=$seed \
        # MODEL=hfl/chinese-roberta-wwm-ext \
        # bash run_experiment.sh "--template_path my_auto_template/eprstmt/16-$seed.txt --template_id $template_id --no_predict"
        # # To save time, we fix these hyper-parameters
        # bs=8
        # lr=1e-5

        # # Since we only use dev performance here, use --no_predict to skip testing
        # TAG=exp-template \
        # TYPE=prompt \
        # TASK=SST-2 \
        # BS=$bs \
        # LR=$lr \
        # SEED=$seed \
        # MODEL=roberta-large \
        # bash run_experiment.sh "--template_path my_auto_template/SST-2/16-$seed.txt --template_id $template_id --no_predict"
    
        SEED=$seed
        TASK=eprstmt
        TYPE=prompt 
        TAG=exp-template

        MODEL=hfl/chinese-roberta-wwm-ext
        BS=8
        LR=1e-5

        TRIAL_IDTF=$RANDOM
        DATA_DIR=data/k-shot/$TASK/$K-$SEED

        python run.py \
            --task_name $TASK \
            --data_dir data/k-shot/$TASK/16-$SEED \
            --overwrite_output_dir \
            --do_train \
            --do_eval \
            --no_predict \
            --evaluate_during_training \
            --model_name_or_path $MODEL\
            --few_shot_type $TYPE \
            --num_k 16 \
            --learning_rate $LR \
            --max_steps 300 \
            --eval_steps 100 \
            --max_seq_len 270 \
            --first_sent_limit 256 \
            --per_device_train_batch_size 4 \
            --per_device_eval_batch_size 16 \
            --learning_rate 1e-5 \
            --output_dir result/$TASK-$TYPE-$K-$SEED-$MODEL-$TRIAL_IDTF \
            --template_path my_auto_template/$TASK/16-$seed.txt \
            --template_id $template_id \
            --mapping "{'Negative':'差','Positive':'好'}" 
    done
done

# Sort templates according to their score
python tools/sort_template.py --condition "{'tag': 'exp-template', 'task_name': $TASK}" --template_dir my_auto_template
