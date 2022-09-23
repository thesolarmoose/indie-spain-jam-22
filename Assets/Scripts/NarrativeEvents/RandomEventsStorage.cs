using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using NaughtyAttributes;
using SaveSystem;
using UnityAtoms.BaseAtoms;
using UnityEngine;
using Utils.Extensions;
using Event = NarrativeEvents.Data.Event;


namespace NarrativeEvents
{
    [CreateAssetMenu(fileName = "RandomEventsStorage", menuName = "Events/RandomEventsStorage", order = 0)]
    public class RandomEventsStorage : ScriptableObject
    {
        [SerializeField] private EventValueList _eventsPool;
        [SerializeField, DisableIf(nameof(Always))] private List<Event> _triggeredEvents;
        [SerializeField, Range(0, 1)] private float _selectFirstChance;

//        private void OnEnable()
//        {
//            LoadData();
//        }
//
//        private async void LoadData()
//        {
//            var loadReport = new SaveUtils.LoadReport {Success = false};
//            try
//            {
//                loadReport = await this.Load();
//            }
//            catch (Exception e)
//            {
//                Debug.LogError(e.ToString());
//            }
//
//            if (!loadReport.Success)
//            {
//                this.ResetToDefault();
//                await this.Save();
//            }
//        }

        public Event Next()
        {
            // TODO
            return _eventsPool.GetRandom();
        }

        private bool Always()
        {
            return true;
        }
    }
}