﻿using System.Threading;
using System.Threading.Tasks;
using ModelView;
using NarrativeEvents.Data;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

namespace NarrativeEvents.UI
{
    public class ChoiceView : ViewBaseBehaviour<(int, Choice, Consequence)>
    {
        [SerializeField] private TextMeshProUGUI _descriptionText;
        [SerializeField] private TextMeshProUGUI _indexText;
        [SerializeField] private Button _button;

        private Consequence _consequence;
        
        public override bool CanRenderModel((int, Choice, Consequence) model)
        {
            return true;
        }

        public override void Initialize((int, Choice, Consequence) model)
        {
            UpdateView(model);
        }

        public override async void UpdateView((int, Choice, Consequence) model)
        {
            var (index, choice, consequence) = model;
            _consequence = consequence;
            _indexText.text = $"{index + 1}";
            var text = await choice.Description.GetLocalizedStringAsync().Task;
            _descriptionText.text = text;
        }

        public async Task<Consequence> WaitPressChoice(CancellationToken ct)
        {
            await AsyncUtils.Utils.WaitPressButtonAsync(_button, ct);
            return _consequence;
        }
    }
}