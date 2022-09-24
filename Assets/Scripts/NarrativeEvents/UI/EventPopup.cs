using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using AsyncUtils;
using BrunoMikoski.AnimationSequencer;
using DG.Tweening;
using NarrativeEvents.Data;
using TMPro;
using UnityEngine;
using UnityEngine.Localization;
using UnityEngine.UI;
using Utils.Extensions;
using Event = NarrativeEvents.Data.Event;

namespace NarrativeEvents.UI
{
    public class EventPopup : AsyncPopupInitializable<Event>
    {
        [SerializeField] private TextMeshProUGUI _eventDescriptionText;
        
        [SerializeField] private Transform _choicesContainer;
        [SerializeField] private ChoiceView _choiceViewPrefab;
        [SerializeField] private Button _continueButton;
        [SerializeField] private AnimationSequencerController _hideAnimation;

        private List<ChoiceView> _populatedViews;
        private bool _hasChoices;
        
        public override async Task Show(CancellationToken ct)
        {
            if (_hasChoices)
            {
                var tasks = _populatedViews.ConvertAll(choiceView => choiceView.WaitPressChoice(ct));
                var task = await Task.WhenAny(tasks);
                var consequences = await task;
                var consequence = consequences.GetRandom();
                
                // disappear choices
                _choicesContainer.gameObject.SetActive(false);
                
                // display consequence 
                await SetDescription(consequence.Description);
                
                await WaitForContinue(ct);

                // apply consequences
                consequence.ExecuteConsequences();
            }
            else
            {
                await WaitForContinue(ct);
            }
        }

        private async Task WaitForContinue(CancellationToken ct)
        {
            // display continue... button
            _continueButton.gameObject.SetActive(true);
            // wait for continue press
            await AsyncUtils.Utils.WaitPressButtonAsync(_continueButton, ct);

            // hide popup
            _hideAnimation.Play();
            await _hideAnimation.PlayingSequence.AsyncWaitForCompletion();
        }

        public override void Initialize(Event @event)
        {
            SetDescription(@event.Description);

            if (@event.HasChoices)
            {
                _continueButton.gameObject.SetActive(false);
                var choices = @event.GetAvailableChoices().ConvertAll(choice => (choice.Choice, choice.Consequences));
                PopulateChoices(choices);
            }
            else
            {
                _choicesContainer.gameObject.SetActive(false);
                _continueButton.gameObject.SetActive(true);
            }
        }

        private void PopulateChoices(IList<(Choice, List<Consequence>)> choices)
        {
            _choicesContainer.ClearChildren();
            _populatedViews = new List<ChoiceView>();
            for (int i = 0; i < choices.Count; i++)
            {
                var (choice, consequences) = choices[i];
                var model = (i, choice, consequences);
                var view = Instantiate(_choiceViewPrefab, _choicesContainer);
                view.Initialize(model);
                _populatedViews.Add(view);
            }
        }

        private async Task SetDescription(LocalizedString localizedString)
        {
            _eventDescriptionText.text = await localizedString.GetLocalizedStringAsync().Task;
        }
    }
}